{ ... }:

let
  # Set to true to install wezterm via nix, false to only manage config
  useNixPackage = false;
  weztermConfig = builtins.readFile ./wezterm.lua;
in
{
  programs.wezterm = {
    enable = useNixPackage;
    extraConfig = weztermConfig;
  };

  # When not using nix package, just place the config file
  xdg.configFile."wezterm/wezterm.lua" = {
    enable = !useNixPackage;
    source = ./wezterm.lua;
  };
}
