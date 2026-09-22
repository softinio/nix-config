{
  pkgs,
  lib,
  ...
}:

let
  # Bear MCP server (https://bear.app/faq/command-line-interface/#mcp-server).
  # Requires Bear 2.8 or later, installed at /Applications/Bear.app.
  bearCli = "/Applications/Bear.app/Contents/MacOS/bearcli";

  # User-scoped MCP servers. Claude Code stores these in ~/.claude.json, a file
  # it owns and rewrites (OAuth session, per-project trust, UI toggles), so it
  # cannot be a home-manager symlink. Instead the activation script below merges
  # these entries into whatever is already there.
  userMcpServers = {
    bear = {
      type = "stdio";
      command = bearCli;
      args = [ "mcp-server" ];
    };
  };

  userMcpServersJson =
    (pkgs.formats.json { }).generate "claude-user-mcp-servers.json" userMcpServers;

  # Define the settings as a Nix attribute set
  settings = {
    attribution = {
      commit = "";
      pr = "";
    };

    env = {
      # Disable Mouse
      CLAUDE_CODE_DISABLE_MOUSE = "1";
    };

    permissions = {
      allow = [
        "Bash(cat:*)"
        "Bash(curl:*)"
        "Bash(find:*)"
        "Bash(gh pr view:*)"
        "Bash(gh api:*)"
        "Bash(gh pr diff:*)"
        "Bash(gh issue view:*)"
        "Bash(gh issue list:*)"
        "Bash(grep:*)"
        "Bash(mill:*)"
        "Bash(poetry:*)"
        "Bash(python3:*)"
        "Bash(sbt:*)"
        "Bash(uv:*)"
        "Bash(xargs cat:*)"
        "WebFetch(domain:github.com)"
        "WebFetch(domain:raw.githubusercontent.com)"
      ];
      deny = [ ];
      ask = [ ];
    };

    # model = "sonnet";

    tui = "default";

    enabledMcpjsonServers = [
      "metals"
    ];

    alwaysThinkingEnabled = true;

    enabledPlugins = {
      "swift-lsp@claude-plugins-official" = true;
    };
  };

  formattedSettings = (pkgs.formats.json { }).generate "claude-settings.json" settings;
in
{
  # Manage Claude Code settings file
  home.file.".claude/settings.json".source = formattedSettings;

  # Global user instructions loaded by Claude Code every session
  home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;

  # GitHub issue lifecycle skill (worktree -> plan -> implement -> PR -> teardown)
  home.file.".claude/skills/github-issue/SKILL.md".source = ./skills/github-issue/SKILL.md;

  # Merge user-scoped MCP servers into ~/.claude.json without clobbering the
  # rest of the file. Re-applied on every rebuild, so an entry Claude Code drops
  # comes back. Existing servers not listed here are left alone.
  home.activation.claudeUserMcpServers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    claudeJson="$HOME/.claude.json"

    if [ -n "''${DRY_RUN_CMD:-}" ]; then
      echo "would merge user-scoped MCP servers into $claudeJson"
    else
      [ -e "$claudeJson" ] || echo '{}' > "$claudeJson"

      if ${pkgs.jq}/bin/jq -e . "$claudeJson" > /dev/null 2>&1; then
        tmp="$(mktemp "$claudeJson.XXXXXX")"
        if ${pkgs.jq}/bin/jq \
          --slurpfile new ${userMcpServersJson} \
          '.mcpServers = ((.mcpServers // {}) + $new[0])' \
          "$claudeJson" > "$tmp"
        then
          mv "$tmp" "$claudeJson"
        else
          rm -f "$tmp"
          echo "warning: failed to merge MCP servers into $claudeJson" >&2
        fi
      else
        echo "warning: $claudeJson is not valid JSON; skipping MCP server merge" >&2
      fi
    fi
  '';
}
