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
          model = "gpt-4o";
        };
      };
      features = {
        copilot = true;
      };
      language_models = {
        openai = {
          available_models = [
            {
              provider = "openai";
              name = "gpt-4o";
              max_tokens = 128000;
            }
            {
              provider = "openai";
              name = "gpt-4o-mini";
              max_tokens = 128000;
            }
          ];
          version = "2";
        };
      };
      telemetry.metrics = false;
      theme = "Andromeda";
      vim_mode = true;
    };
  };
}
