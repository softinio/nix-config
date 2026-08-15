{ pkgs, inputs, ... }:

let
  herdrPkg = inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Builds (and tears down) the per-worktree herdr workspace layout.
  # Encapsulated here rather than copy-pasted
  # into each SKILL.md so the pane ids, JSON shapes and teardown live in one place.
  #
  #   TAB 1 "{name}"                   TAB 2 "build"
  #   +----------+----------+          +----------+----------+
  #   | Claude   | reviewr  |          | nvim     | build    |
  #   +----------+----------+          +----------+----------+
  #
  # reviewr gets a full-height pane in the tab Claude lives in — the diff is the thing
  # you actually read — while nvim and the build tool sit one tab away.
  workspaceLayout = pkgs.writeShellApplication {
    name = "herdr-workspace-layout";
    runtimeInputs = [
      herdrPkg
      pkgs.jq
      pkgs.coreutils
      pkgs.git
    ];
    text = ''
      usage() {
        cat <<'EOF'
      Usage:
        herdr-workspace-layout open <worktree-path> [name]
        herdr-workspace-layout close

      The workspace and its first tab are named <name>. When omitted, the name is the
      worktree's branch with any owner prefix stripped (salar/add-caching -> add-caching),
      falling back to the worktree directory name.

      The build pane picks its command from the worktree: `sbt --client` for an sbt
      project, `mill -w __.compile` for a mill one, otherwise a plain shell. Set
      HERDR_BUILD_CMD to override.

      Outside a herdr pane both subcommands are a no-op and exit 0.
      EOF
      }

      # Every creation command answers with JSON. The pane id sits at a different path
      # depending on the command, so probe the known shapes rather than guessing one.
      pane_id_from() {
        jq -r '.result.pane.pane_id // .result.plugin_pane.pane.pane_id // empty'
      }

      # Close reviewr by sweeping its labelled panes rather than invoking the plugin's own
      # close action. That action validates reviewr's whole config before it will touch a
      # pane, so an unparseable config leaves the pane both broken and unclosable. herdr
      # labels plugin panes, and a plain `pane close` is what the plugin does internally.
      close_reviewr_panes() {
        local ids id
        ids=$(herdr pane list --workspace "$HERDR_WORKSPACE_ID" \
          | jq -r '.result.panes[] | select(.label == "reviewr") | .pane_id')
        for id in $ids; do
          herdr pane close "$id" >/dev/null 2>&1 || true
        done
      }

      # What the build pane runs, by build tool. Empty output means "leave a prompt":
      # a bare shell in the worktree is more useful than a command that errors out.
      #
      # sbt has a persistent client worth parking in a pane; mill does not, so it gets
      # watch-compile, which is the closest long-running equivalent (Ctrl-C drops back to
      # the prompt with the dev shell already loaded). HERDR_BUILD_CMD overrides both.
      detect_build_cmd() {
        local worktree="$1" mill
        if [ -n "''${HERDR_BUILD_CMD:-}" ]; then
          printf '%s' "$HERDR_BUILD_CMD"
        elif [ -x "$worktree/mill" ] || [ -x "$worktree/millw" ] \
          || [ -f "$worktree/build.mill" ] || [ -f "$worktree/build.mill.scala" ] \
          || [ -f "$worktree/build.sc" ] || [ -f "$worktree/.mill-version" ]; then
          # Prefer the checked-in wrapper: it pins the mill version the project expects.
          if [ -x "$worktree/mill" ]; then mill=./mill
          elif [ -x "$worktree/millw" ]; then mill=./millw
          else mill=mill
          fi
          printf '%s' "$mill -w __.compile"
        elif [ -f "$worktree/build.sbt" ] || [ -f "$worktree/project/build.properties" ]; then
          printf '%s' "sbt --client"
        fi
      }

      # The workspace name is the branch, minus the owner prefix jj/git push bookmarks add:
      # short enough for a tab, and it still matches what the agent sidebar shows.
      derive_name() {
        local worktree="$1" branch
        branch=$(git -C "$worktree" symbolic-ref --quiet --short HEAD 2>/dev/null || true)
        if [ -n "$branch" ]; then
          printf '%s\n' "''${branch##*/}"
        else
          basename "$worktree"
        fi
      }

      cmd_open() {
        local worktree="$1" name="''${2:-}"

        if [ ! -d "$worktree" ]; then
          echo "herdr-workspace-layout: no such worktree: $worktree" >&2
          return 1
        fi
        worktree=$(cd "$worktree" && pwd -P)
        [ -n "$name" ] || name=$(derive_name "$worktree")

        herdr workspace rename "$HERDR_WORKSPACE_ID" "$name" >/dev/null
        herdr tab rename "$HERDR_TAB_ID" "$name" >/dev/null

        # --- Tab 1: reviewr, full height, to the right of Claude ------------------
        # Close any sidebar that auto-opened in the wrong slot first (no-op if none).
        # `plugin action invoke open` is deliberately not used: it derives its cwd and
        # split target from the *focused* pane, which is Claude's — in the main worktree,
        # not this one. Opening the pane directly is the only way to pin both.
        close_reviewr_panes

        local reviewr_pane
        reviewr_pane=$(herdr plugin pane open \
          --plugin persiyanov.reviewr --entrypoint pane \
          --placement split --target-pane "$HERDR_PANE_ID" --direction right \
          --cwd "$worktree" --no-focus | pane_id_from)

        # --- Tab 2: nvim | build ---------------------------------------------------
        local before after build_tab
        before=$(herdr tab list --workspace "$HERDR_WORKSPACE_ID" | jq -r '.result.tabs[].tab_id' | sort)

        build_tab=$(herdr tab create \
          --workspace "$HERDR_WORKSPACE_ID" --cwd "$worktree" --label build --no-focus \
          | jq -r '.result.tab.tab_id // .result.tab_id // empty')

        # Fall back to diffing the tab list if `tab create` ever changes its response shape.
        if [ -z "$build_tab" ]; then
          after=$(herdr tab list --workspace "$HERDR_WORKSPACE_ID" | jq -r '.result.tabs[].tab_id' | sort)
          build_tab=$(comm -13 <(printf '%s\n' "$before") <(printf '%s\n' "$after") | head -1)
        fi

        if [ -z "$build_tab" ]; then
          echo "herdr-workspace-layout: could not resolve the new build tab" >&2
          return 1
        fi

        local nvim_pane build_pane build_cmd
        nvim_pane=$(herdr pane list \
          | jq -r --arg t "$build_tab" '.result.panes[] | select(.tab_id == $t) | .pane_id' | head -1)

        build_pane=$(herdr pane split "$nvim_pane" \
          --direction right --cwd "$worktree" --no-focus | pane_id_from)

        build_cmd=$(detect_build_cmd "$worktree")

        # The panes already start in the worktree, where .envrc lives; the cd is
        # belt-and-suspenders so direnv loads the flake dev shell.
        herdr pane run "$nvim_pane" "cd $worktree && nvim ." >/dev/null
        if [ -n "$build_cmd" ]; then
          herdr pane run "$build_pane" "cd $worktree && $build_cmd" >/dev/null
        else
          herdr pane run "$build_pane" "cd $worktree" >/dev/null
        fi

        echo "herdr-workspace-layout: $name ready — reviewr $reviewr_pane, build tab $build_tab (nvim $nvim_pane, build $build_pane: ''${build_cmd:-shell})"
      }

      cmd_close() {
        # Panes are found by label, not by ids remembered from `open`, so teardown works
        # from a fresh shell and survives however long the work took.
        local build_tab
        build_tab=$(herdr tab list --workspace "$HERDR_WORKSPACE_ID" \
          | jq -r '.result.tabs[] | select(.label == "build") | .tab_id' | head -1)

        if [ -n "$build_tab" ]; then
          herdr tab close "$build_tab" >/dev/null && echo "herdr-workspace-layout: closed build tab $build_tab"
        fi

        close_reviewr_panes
        echo "herdr-workspace-layout: closed reviewr"
      }

      case "''${1:-}" in
        open)
          if [ "$#" -lt 2 ]; then usage >&2; exit 2; fi
          ;;
        close) ;;
        ""|-h|--help|help) usage; exit 0 ;;
        *) usage >&2; exit 2 ;;
      esac

      # Claude is not always run inside herdr. Skip silently rather than failing the caller.
      if [ -z "''${HERDR_WORKSPACE_ID:-}" ] || [ -z "''${HERDR_PANE_ID:-}" ] || [ -z "''${HERDR_TAB_ID:-}" ]; then
        echo "herdr-workspace-layout: not running inside a herdr pane — skipping layout"
        exit 0
      fi

      sub="$1"
      shift
      case "$sub" in
        open) cmd_open "$@" ;;
        close) cmd_close ;;
      esac
    '';
  };
in
{
  home.packages = [
    herdrPkg
    workspaceLayout
  ];

  home.file.".config/herdr/config.toml".text = ''
    onboarding = false

    [theme]
    name = "tokyo-night"

    [theme.custom]
    accent = "orange"

    [ui]
    show_agent_labels_on_pane_borders = true
    accent = "orange"

    [ui.sound]
    enabled = false

    [ui.toast]
    delivery = "herdr"
    delay_seconds = 1

    # Several workspaces run at once, so the agent sidebar needs to say which
    # worktree a blocked agent belongs to, not just that something is blocked.
    [ui.sidebar.agents]
    rows = [
      ["state_icon", "agent", "state_text"],
      ["workspace", "branch"],
    ]

    [keys]
    split_vertical = "prefix+'"
    split_horizontal = "prefix+minus"

    [[keys.command]]
    key = "prefix+r"
    type = "plugin_action"
    command = "persiyanov.reviewr.toggle"

    [experimental]
    pane_history = true
  '';

  # herdr-reviewr plugin (persiyanov/herdr-reviewr). The plugin is installed imperatively
  # with `herdr plugin install persiyanov/herdr-reviewr`; only its config lives here.
  # Any unknown key or invalid value invalidates the whole file; reviewr re-reads it on
  # every refresh, so edits apply without relaunching the pane.
  #
  # Do not reintroduce `base_branches`: reviewr 0.30.0 retired it, and because the parse is
  # whole-file, carrying the key silently disabled every setting below it. Pick the base
  # with `B` in the pane instead — that choice persists in refs/reviewr/. Note it is stored
  # per *repo*, so it is shared by every worktree of that repo; for a stacked branch whose
  # base is not main, reach for `tuicr -r <base>...HEAD` rather than fighting the pick.
  home.file.".config/herdr/plugins/config/persiyanov.reviewr/config.toml".text = ''
    theme = "tokyo-night"
    default_scope = "branch"
    navigator_position = "right"
    toggle_placement = "split"
    toggle_direction = "down"
    auto_open = false
  '';
}
