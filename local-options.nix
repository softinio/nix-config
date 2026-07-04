# Local (non-upstream) module options for this configuration.
# Declaring these as real options lets a machine override them, and keeps the
# per-module let-binding toggles out of the program modules.
{ lib, ... }:

{
  options.local = {
    wezterm = {
      useNixPackage = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Install wezterm via nix (true) or only manage its config file (false).";
      };
      useMux = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the wezterm unix-domain multiplexer on startup.";
      };
    };
    zed.useNixPackage = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install zed via nix (true) or only manage its config file (false).";
    };
  };
}
