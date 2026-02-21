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
    "zig"
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
          model = "claude-sonnet-4-6";
        };
      };
      autosave = "on_focus_change";
      auto_update = false;
      features = {
        edit_prediction_provider = "copilot";
      };
      language_models = {
        anthropic = {
          available_models = [
            {
              name = "claude-sonnet-4-6";
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
              name = "gpt-5.2-codex";
              display_name = "gpt-5.2-codex";
              reasoning_effort = "high";
              max_tokens = 272000;
              max_completion_tokens = 20000;
            }
          ];
        };
      };
      load_direnv = "shell_hook";
      telemetry.metrics = false;
      terminal = {
        copy_on_select = true;
        dock = "bottom";
      };
      theme = "Ayu Dark";
      vim_mode = true;
    };
  };
}
