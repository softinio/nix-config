{ config, pkgs, ... }:
let
  myverbs = [
    {
      invocation = "panel_right";
      key = "alt-right";
      internal = ":panel_right";
    }
    {
      invocation = "panel_left_no_open";
      key = "alt-left";
      internal = ":panel_left_no_open";
    }
  ];
in
{
  programs.broot = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      modal = true;
      verbs = myverbs;
    };
  };
}
