{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Define the settings as a Nix attribute set
  settings = {
    attribution = {
      commit = "";
      pr = "";
    };

    permissions = {
      allow = [
        "Bash(cat:*)"
        "Bash(curl:*)"
        "Bash(find:*)"
        "Bash(gh pr view:*)"
        "Bash(gh api:*)"
        "Bash(gh pr diff:*)"
        "Bash(grep:*)"
        "Bash(mill:*)"
        "Bash(python3:*)"
        "Bash(sbt:*)"
        "Bash(uv:*)"
        "Bash(xargs cat:*)"
        "WebFetch(domain:twitter.github.io)"
      ];
      deny = [ ];
      ask = [ ];
    };

    model = "sonnet";

    enabledMcpjsonServers = [
      "metals"
    ];

    alwaysThinkingEnabled = true;

    enabledPlugins = {
      "swift-lsp@claude-plugins-official" = true;
    };
  };

  # Generate formatted JSON using jq
  formattedSettings =
    pkgs.runCommand "claude-settings.json"
      {
        buildInputs = [ pkgs.jq ];
        json = builtins.toJSON settings;
      }
      ''
        echo "$json" | jq '.' > $out
      '';
in
{
  # Manage Claude Code settings file
  home.file.".claude/settings.json".source = formattedSettings;
}
