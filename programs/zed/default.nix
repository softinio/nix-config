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
      features = {
        copilot = true;
      };
      telemetry.metrics = false;
      theme = "Andromeda";
      vim_mode = true;
    };
  };
}
