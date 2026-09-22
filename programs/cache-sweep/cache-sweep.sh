#!/usr/bin/env bash
#
# cache-sweep.sh
#
# Reclaims disk from regenerable developer caches in the home directory.
# Companion to worktree-audit, which only reaches caches that live inside a git
# worktree; these grow independently of any repo and nothing else prunes them.
#
# Two strategies, chosen per cache in the lists below:
#
#   entry caches  A directory of independent per-project or per-package entries.
#                 Entries not modified in --age days are deleted individually,
#                 so the entries you still use survive.
#   whole caches  A directory with an internal index, where deleting some
#                 entries would leave the rest inconsistent. Removed wholesale,
#                 and only when nothing inside has been touched in --age days,
#                 i.e. when you have stopped using that toolchain entirely.
#
# Everything listed is rebuilt on demand by the tool that owns it. Caches that
# are slow or impossible to refetch are deliberately excluded: poetry's
# virtualenvs (real state, not a cache), ~/.cache/huggingface (model weights)
# and the Coursier caches (every Scala build pays for a miss).
#
# Compatible with the default bash 3.2 shipped on macOS.
#
# It also purges stale build output inside project trees: target (including the
# nested ones sbt and Mill create per module), out, .bloop, .bsp and .metals.
# worktree-audit clears those unconditionally but only inside linked worktrees,
# so main checkouts -- where most Scala work happens -- keep theirs forever.
# Here the age check does the deciding, and a directory is only ever removed
# when git ignores it, so anything a repo actually tracks is left alone.
#
# Usage:
#   ./cache-sweep.sh [options] [project-root ...]
#
# Options:
#   -a, --age DAYS   Treat a cache entry as stale after this many days (default: 30)
#   -y, --yes        Actually delete. Without it the script only reports.
#   -h, --help       Show this help
#
# Project roots default to ~/Projects, ~/OpenSource and ~/Learn when they exist.
#
# Exits 0 even when nothing is stale, so a scheduled run stays quiet.

set -o pipefail

AGE=30
ASSUME_YES=0
PROJECT_ROOTS=()

usage() { awk 'NR == 1 { next } /^#/ { sub(/^# ?/, ""); print; next } { exit }' "$0"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    -a|--age)
      if [[ -z "$2" || "$2" =~ [^0-9] ]]; then
        echo "--age needs a number of days" >&2
        exit 2
      fi
      AGE="$2"; shift 2 ;;
    -y|--yes) ASSUME_YES=1; shift ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "unknown option: $1" >&2; exit 2 ;;
    *) PROJECT_ROOTS+=("$1"); shift ;;
  esac
done

if [[ ${#PROJECT_ROOTS[@]} -eq 0 ]]; then
  for d in "$HOME/Projects" "$HOME/OpenSource" "$HOME/Learn"; do
    [[ -d "$d" ]] && PROJECT_ROOTS+=("$d")
  done
fi

# Build output, all of it regenerable by the build tool that wrote it.
BUILD_DIRS=(target out .bloop .bsp .metals)
FIND_BUILD_EXPR=()
for n in "${BUILD_DIRS[@]}"; do
  [[ ${#FIND_BUILD_EXPR[@]} -gt 0 ]] && FIND_BUILD_EXPR+=(-o)
  FIND_BUILD_EXPR+=(-name "$n")
done

# Per-entry pruning: immediate children older than $AGE go.
ENTRY_CACHES=(
  "$HOME/Library/Developer/Xcode/DerivedData"
  "$HOME/Library/Caches/pypoetry/artifacts"
  "$HOME/Library/Caches/pypoetry/cache"
  "$HOME/.npm/_npx"
  "$HOME/.npm/_logs"
)

# Wholesale removal, but only once the entire tree has gone $AGE days untouched.
WHOLE_CACHES=(
  "$HOME/.cache/uv"
  "$HOME/Library/Caches/Yarn"
  "$HOME/.npm/_cacache"
)

human() { du -sh "$1" 2>/dev/null | cut -f1; }

FREED_NOTE="would free"
[[ $ASSUME_YES -eq 1 ]] && FREED_NOTE="freed"

echo "== cache-sweep: entries older than ${AGE} days =="
[[ $ASSUME_YES -eq 0 ]] && echo "(report only -- pass --yes to delete)"

echo
echo "== 1. Per-entry caches =="
for root in "${ENTRY_CACHES[@]}"; do
  [[ -d "$root" ]] || continue
  stale=()
  while IFS= read -r e; do
    [[ -n "$e" ]] && stale+=("$e")
  done < <(find "$root" -mindepth 1 -maxdepth 1 -mtime +"$AGE" 2>/dev/null)

  if [[ ${#stale[@]} -eq 0 ]]; then
    printf "%-52s %6s  nothing stale\n" "${root/#$HOME/~}" "$(human "$root")"
    continue
  fi

  printf "%-52s %6s  %d stale entries\n" "${root/#$HOME/~}" "$(human "$root")" "${#stale[@]}"
  for e in "${stale[@]}"; do
    printf "    %-8s %s\n" "$(human "$e")" "$(basename "$e")"
    [[ $ASSUME_YES -eq 1 ]] && rm -rf -- "$e"
  done
  [[ $ASSUME_YES -eq 1 ]] && printf "  -> now %s\n" "$(human "$root")"
done

echo
echo "== 2. Whole caches, dropped only when the toolchain has gone idle =="
for root in "${WHOLE_CACHES[@]}"; do
  [[ -d "$root" ]] || continue
  recent=$(find "$root" -mtime -"$AGE" -print -quit 2>/dev/null)
  if [[ -n "$recent" ]]; then
    printf "%-52s %6s  in use, kept\n" "${root/#$HOME/~}" "$(human "$root")"
    continue
  fi
  printf "%-52s %6s  idle >%s days, %s\n" "${root/#$HOME/~}" "$(human "$root")" "$AGE" "$FREED_NOTE"
  [[ $ASSUME_YES -eq 1 ]] && rm -rf -- "$root"
done

echo
echo "== 3. Stale build output in project trees =="
if [[ ${#PROJECT_ROOTS[@]} -eq 0 ]]; then
  echo "No project roots given or found, skipping."
else
  echo "Roots: ${PROJECT_ROOTS[*]}"
  build_total=0
  while IFS= read -r d; do
    [[ -n "$d" ]] || continue
    # Only ever touch what git ignores: tracked output stays, and a directory
    # outside a repo is left alone entirely.
    git -C "$d" rev-parse --show-toplevel >/dev/null 2>&1 || continue
    git -C "$d" check-ignore -q "$d" 2>/dev/null || continue
    # The directory's own mtime lies -- a build rewrites files nested inside it
    # without touching the top level -- so ask for the newest file anywhere in
    # the tree instead.
    recent=$(find "$d" -mtime -"$AGE" -print -quit 2>/dev/null)
    [[ -n "$recent" ]] && continue
    printf "    %-8s %s\n" "$(human "$d")" "${d/#$HOME/~}"
    build_total=$((build_total + 1))
    [[ $ASSUME_YES -eq 1 ]] && rm -rf -- "$d"
  done < <(find "${PROJECT_ROOTS[@]}" -maxdepth 8 -type d \( "${FIND_BUILD_EXPR[@]}" \) -prune -print 2>/dev/null)
  if [[ $build_total -eq 0 ]]; then
    echo "  Nothing stale."
  else
    echo "  ${build_total} stale build directories, ${FREED_NOTE}."
  fi
fi

echo
echo "== 4. Disk =="
df -h /nix / 2>/dev/null | awk 'NR == 1 || /\/nix$|\/$/'

echo
echo "Done."
