{ ... }:
let
  myextensions = [
    "fish"
    "lua"
    "nix"
    "pyrefly"
    "python"
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
