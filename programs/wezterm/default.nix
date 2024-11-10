{ ... }:

let
  weztermConfig = builtins.readFile ./wezterm.lua;
in
{
  programs.wezterm = {
    enable = true;
    extraConfig = weztermConfig;
  };
}
