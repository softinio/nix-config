#!/usr/bin/env bash
#
# worktree-audit.sh
#
# Finds all git worktrees across one or more base repos, reports their disk
# usage, flags stale/prunable worktrees, checks whether they're pinning
# Nix store garbage collection roots, and (optionally) cleans things up.
#
# Compatible with the default bash 3.2 shipped on macOS (no mapfile, no
# reliance on set -u array-expansion behavior).
#
# Usage:
#   ./worktree-audit.sh [options] [search-root ...]
#
# Options:
#   -c, --cleanup        Interactively remove stale worktrees (prompts per item)
#   -k, --clean-caches   Interactively remove node_modules/target/.venv/.direnv/dist/build
#                        dirs inside worktrees you KEEP (prompts per item, never touches
#                        worktrees being removed by --cleanup in the same run)
#   -m, --skip-main      With --clean-caches, leave each repo's main checkout alone and
#                        only clean linked worktrees
#   -d, --cache-dirs L   Comma-separated dir names treated as caches
#                        (default: node_modules,target,.venv,.direnv,dist,build)
#   -y, --yes            Combine with --cleanup and/or --clean-caches to skip prompts
#   -g, --gc             Run `nix-collect-garbage -d` after cleanup
#   -o, --optimise       Run `nix-store --optimise` after gc
#   -h, --help           Show this help
#
# If no search-root is given, defaults to $HOME.
#
# What it does NOT do: it never force-deletes a worktree with uncommitted
# changes without telling you first, and it never touches worktrees that
# are still checked out to a branch with unmerged/unique commits without
# an explicit confirmation.

set -o pipefail

CLEANUP=0
CLEAN_CACHES=0
ASSUME_YES=0
RUN_GC=0
RUN_OPTIMISE=0
SKIP_MAIN=0
CACHE_DIRS="node_modules,target,.venv,.direnv,dist,build"
SEARCH_ROOTS=()

# Prints the contiguous comment header, however long it grows
usage() { awk 'NR == 1 { next } /^#/ { sub(/^# ?/, ""); print; next } { exit }' "$0"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--cleanup) CLEANUP=1; shift ;;
    -k|--clean-caches) CLEAN_CACHES=1; shift ;;
    -m|--skip-main) SKIP_MAIN=1; shift ;;
    -d|--cache-dirs)
      if [[ -z "$2" ]]; then
        echo "--cache-dirs needs a comma-separated list" >&2
        exit 2
      fi
      CACHE_DIRS="$2"; shift 2 ;;
    -y|--yes) ASSUME_YES=1; shift ;;
    -g|--gc) RUN_GC=1; shift ;;
    -o|--optimise) RUN_OPTIMISE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) SEARCH_ROOTS+=("$1"); shift ;;
  esac
done
if [[ ${#SEARCH_ROOTS[@]} -eq 0 ]]; then
  SEARCH_ROOTS=("$HOME")
fi

have() { command -v "$1" >/dev/null 2>&1; }

# Builds `-name a -o -name b ...` for find from CACHE_DIRS
CACHE_NAMES=()
IFS=',' read -r -a CACHE_NAMES <<< "$CACHE_DIRS"
FIND_CACHE_EXPR=()
for n in "${CACHE_NAMES[@]}"; do
  [[ -z "$n" ]] && continue
  [[ ${#FIND_CACHE_EXPR[@]} -gt 0 ]] && FIND_CACHE_EXPR+=(-o)
  FIND_CACHE_EXPR+=(-name "$n")
done
if [[ ${#FIND_CACHE_EXPR[@]} -eq 0 ]]; then
  echo "--cache-dirs must name at least one directory" >&2
  exit 2
fi

echo "== 1. Locating git repos under: ${SEARCH_ROOTS[*]} =="
GIT_DIRS=()
while IFS= read -r line; do
  [[ -n "$line" ]] && GIT_DIRS+=("$line")
done < <(find "${SEARCH_ROOTS[@]}" -maxdepth 6 -type d -name ".git" 2>/dev/null)

if [[ ${#GIT_DIRS[@]} -eq 0 ]]; then
  echo "No git repos found. Try a different search root or increase --maxdepth in the script."
  exit 0
fi

ALL_WT_PATHS=()
ALL_WT_REPO=()
ALL_WT_BRANCH=()
ALL_WT_PRUNABLE=()

echo
echo "== 2. Enumerating worktrees =="
for gd in "${GIT_DIRS[@]}"; do
  repo="$(dirname "$gd")"
  [[ -d "$gd" ]] || continue
  pushd "$repo" >/dev/null 2>&1 || continue
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    wt_path=""; wt_branch=""; wt_prunable=""
    while IFS= read -r line; do
      case "$line" in
        worktree\ *) wt_path="${line#worktree }" ;;
        branch\ *) wt_branch="${line#branch }" ;;
        detached) wt_branch="(detached)" ;;
        prunable*) wt_prunable="yes" ;;
        "")
          if [[ -n "$wt_path" ]]; then
            ALL_WT_PATHS+=("$wt_path")
            ALL_WT_REPO+=("$repo")
            if [[ -n "$wt_branch" ]]; then
              ALL_WT_BRANCH+=("$wt_branch")
            else
              ALL_WT_BRANCH+=("unknown")
            fi
            if [[ -n "$wt_prunable" ]]; then
              ALL_WT_PRUNABLE+=("$wt_prunable")
            else
              ALL_WT_PRUNABLE+=("no")
            fi
          fi
          wt_path=""; wt_branch=""; wt_prunable=""
          ;;
      esac
    done < <(git worktree list --porcelain 2>/dev/null; echo)
  fi
  popd >/dev/null 2>&1
done

if [[ ${#ALL_WT_PATHS[@]} -eq 0 ]]; then
  echo "No worktrees found."
  exit 0
fi

echo
echo "== 3. Sizes (this may take a while for large trees) =="
printf "%-10s %-8s %-40s %s\n" "SIZE" "PRUNABLE" "BRANCH" "PATH"
WT_SIZE_BYTES=()
i=0
while [[ $i -lt ${#ALL_WT_PATHS[@]} ]]; do
  p="${ALL_WT_PATHS[$i]}"
  if [[ -d "$p" ]]; then
    sz=$(du -sh "$p" 2>/dev/null | cut -f1)
    szb=$(du -sk "$p" 2>/dev/null | cut -f1)
  else
    sz="MISSING"; szb=0
  fi
  WT_SIZE_BYTES+=("$szb")
  printf "%-10s %-8s %-40s %s\n" "$sz" "${ALL_WT_PRUNABLE[$i]}" "${ALL_WT_BRANCH[$i]}" "$p"
  i=$((i+1))
done

echo
echo "== 4. Dev/build cache dirs inside worktrees (${CACHE_DIRS}) =="
find "${ALL_WT_PATHS[@]}" -maxdepth 3 -type d \( "${FIND_CACHE_EXPR[@]}" \) \
  2>/dev/null | while read -r d; do
    du -sh "$d" 2>/dev/null
  done | sort -rh | head -20

if have nix; then
  echo
  echo "== 5. Nix store GC roots pinned by worktree paths =="
  ROOT_OUTPUT=$(nix-store --gc --print-roots 2>/dev/null | grep -v '^/proc')
  FOUND_ROOTS=0
  for p in "${ALL_WT_PATHS[@]}"; do
    matches=$(echo "$ROOT_OUTPUT" | grep -F "$p" || true)
    if [[ -n "$matches" ]]; then
      FOUND_ROOTS=1
      echo "-- Roots referencing $p:"
      echo "$matches"
    fi
  done
  [[ $FOUND_ROOTS -eq 0 ]] && echo "No Nix GC roots found pinned to any worktree path."

  echo
  echo "== 6. Current /nix usage =="
  # df rather than `du -sh /nix/store`: du walks every file in the store, which
  # takes minutes once it is a few hundred GB, to report what df reads straight
  # off the volume header. Assumes /nix is its own volume, as nix-darwin sets
  # up; if it is not, this reports the volume holding it.
  df -h /nix 2>/dev/null
else
  echo
  echo "== 5/6. Nix not found on PATH, skipping Nix-related checks =="
fi

if [[ $CLEANUP -eq 0 && $CLEAN_CACHES -eq 0 ]]; then
  echo
  echo "Run with --cleanup (-c) to interactively remove prunable/unwanted worktrees,"
  echo "and/or --clean-caches (-k) to clear node_modules/target/.venv/etc inside worktrees"
  echo "you keep, optionally followed by --gc to reclaim Nix store space."
  exit 0
fi

REMOVED_PATHS=()

if [[ $CLEANUP -eq 1 ]]; then
echo
echo "== 7. Cleanup =="
i=0
while [[ $i -lt ${#ALL_WT_PATHS[@]} ]]; do
  p="${ALL_WT_PATHS[$i]}"
  repo="${ALL_WT_REPO[$i]}"
  branch="${ALL_WT_BRANCH[$i]}"
  prunable="${ALL_WT_PRUNABLE[$i]}"

  if [[ "$p" == "$repo" ]]; then
    i=$((i+1))
    continue
  fi

  pushd "$repo" >/dev/null 2>&1 || { i=$((i+1)); continue; }
  dirty=""
  if [[ -d "$p" ]]; then
    dirty=$(git -C "$p" status --porcelain 2>/dev/null)
  fi
  popd >/dev/null 2>&1

  reason=""
  [[ "$prunable" == "yes" ]] && reason="marked prunable by git"
  [[ ! -d "$p" ]] && reason="directory missing (safe to prune metadata)"
  if [[ -z "$reason" && -z "$dirty" ]]; then
    reason="clean working tree, no uncommitted changes"
  fi

  echo
  echo "Worktree: $p"
  echo "  Repo:    $repo"
  echo "  Branch:  $branch"
  [[ -n "$dirty" ]] && echo "  WARNING: has uncommitted changes:" && echo "$dirty" | sed 's/^/    /'
  [[ -n "$reason" ]] && echo "  Reason to consider removal: $reason"

  if [[ -n "$dirty" && "$ASSUME_YES" -eq 1 ]]; then
    echo "  Skipping (uncommitted changes present, refusing to auto-remove even with --yes)."
    i=$((i+1))
    continue
  fi

  do_remove=0
  if [[ $ASSUME_YES -eq 1 ]]; then
    do_remove=1
  else
    read -r -p "  Remove this worktree? [y/N] " ans
    [[ "$ans" =~ ^[Yy]$ ]] && do_remove=1
  fi

  if [[ $do_remove -eq 1 ]]; then
    pushd "$repo" >/dev/null 2>&1
    if [[ -d "$p" ]]; then
      git worktree remove --force "$p" && echo "  Removed." && REMOVED_PATHS+=("$p")
    else
      git worktree prune && echo "  Pruned missing worktree metadata." && REMOVED_PATHS+=("$p")
    fi
    popd >/dev/null 2>&1
  else
    echo "  Skipped."
  fi
  i=$((i+1))
done
fi

is_removed() {
  local target="$1"
  local r
  for r in "${REMOVED_PATHS[@]}"; do
    [[ "$r" == "$target" ]] && return 0
  done
  return 1
}

if [[ $CLEAN_CACHES -eq 1 ]]; then
  echo
  echo "== 7b. Clean caches in kept worktrees =="
  i=0
  while [[ $i -lt ${#ALL_WT_PATHS[@]} ]]; do
    p="${ALL_WT_PATHS[$i]}"
    repo="${ALL_WT_REPO[$i]}"
    i=$((i+1))

    if [[ ${#REMOVED_PATHS[@]} -gt 0 ]] && is_removed "$p"; then
      continue
    fi
    [[ -d "$p" ]] || continue
    if [[ $SKIP_MAIN -eq 1 && "$p" == "$repo" ]]; then
      echo
      echo "Skipping main checkout: $p"
      continue
    fi

    cache_dirs=()
    while IFS= read -r cd; do
      [[ -n "$cd" ]] && cache_dirs+=("$cd")
    done < <(find "$p" -maxdepth 3 -type d \( "${FIND_CACHE_EXPR[@]}" \) 2>/dev/null)

    [[ ${#cache_dirs[@]} -eq 0 ]] && continue

    echo
    echo "Worktree: $p"
    for cd in "${cache_dirs[@]}"; do
      sz=$(du -sh "$cd" 2>/dev/null | cut -f1)
      echo "  Found: $cd ($sz)"

      do_delete=0
      if [[ $ASSUME_YES -eq 1 ]]; then
        do_delete=1
      else
        read -r -p "    Delete this directory? [y/N] " ans
        [[ "$ans" =~ ^[Yy]$ ]] && do_delete=1
      fi

      if [[ $do_delete -eq 1 ]]; then
        rm -rf -- "$cd" && echo "    Deleted."
      else
        echo "    Skipped."
      fi
    done
  done
fi

if have nix; then
  if [[ $RUN_GC -eq 1 ]]; then
    echo
    echo "== 8. Running nix-collect-garbage -d =="
    nix-collect-garbage -d
  fi
  if [[ $RUN_OPTIMISE -eq 1 ]]; then
    echo
    echo "== 9. Running nix-store --optimise =="
    nix-store --optimise
  fi
  if [[ $RUN_GC -eq 1 || $RUN_OPTIMISE -eq 1 ]]; then
    echo
    echo "== Final /nix usage =="
    df -h /nix 2>/dev/null
  fi
fi

echo
echo "Done."
