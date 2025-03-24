{ ... }:
let
  myextensions = [
    "fish"
    "lua"
    "nix"
    "ruff"
    "scala"
    "sql"
    "swift"
    "toml"
  ];
in
{
  programs.zed-editor = {
    enable = true;
    extensions = myextensions;
    userSettings = {
      assistant = {
        version = "2";
        default_model = {
          provider = "copilot_chat";
          model = "claude-3-7-sonnet";
        };
      };
      features = {
        copilot = true;
      };
      language_models = {
        anthropic = {
          available_models = [
            {
              provider = "anthropic";
              name = "claude-3-7-sonnet";
              max_tokens = 128000;
              cache_configuration = {
                max_cache_anchors = 10;
                min_total_token = 10000;
                should_speculate = false;
              };
            }
          ];
          version = "1";
        };
        openai = {
          available_models = [
            {
              provider = "openai";
              name = "gpt-4o";
              max_tokens = 128000;
            }
            {
              provider = "openai";
              name = "o3-mini";
              max_tokens = 128000;
            }
          ];
          version = "1";
        };
      };
      telemetry.metrics = false;
      theme = "Gruvbox Dark Hard";
      vim_mode = true;
    };
  };
}
