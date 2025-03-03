{ pkgs, ... }:
let
  mySettings = {
    copy-on-select = "clipboard";
    font-family = "SF Mono";
    font-size = 16;
    macos-title-bar-style = "transparent";
    theme = "Builtin Tango Dark";
    window-inherit-working-directory = true;
    working-directory = "home";
  };
in
{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
    settings = mySettings;
  };
}
