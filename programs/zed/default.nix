{ ... }:
let
  myextensions = [
    "fish"
    "lua"
    "nix"
    "pyrefly"
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
      agent = {
        default_model = {
          provider = "copilot_chat";
          model = "claude-4-sonnet";
        };
      };
      language_models = {
        anthropic = {
          available_models = [
            {
              name = "claude-sonnet-4-20250514";
              max_tokens = 200000;
              cache_configuration = {
                max_cache_anchors = 10;
                min_total_token = 10000;
                should_speculate = false;
              };
            }
          ];
        };
        openai = {
          available_models = [
            {
              name = "gpt-5";
              display_name = "gpt-5 high";
              reasoning_effort = "high";
              max_tokens = 272000;
              max_completion_tokens = 20000;
            }
          ];
        };
      };
      telemetry.metrics = false;
      theme = "Gruvbox Dark Hard";
      vim_mode = true;
    };
  };
}
