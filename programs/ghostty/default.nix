{ pkgs, ... }:
let
  my_settings = {
    auto-update = "off";
    copy-on-select = "clipboard";
    font-family = "SF Mono";
    font-size = 16;
    macos-titlebar-style = "transparent";
    mouse-hide-while-typing = true;
    split-divider-color = "orange";
    theme = "Builtin Tango Dark";
    window-inherit-working-directory = true;
    window-save-state = "always";
    working-directory = "home";
    keybind = [
      "shift+enter=text:\n"
    ];
  };
in
{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    installVimSyntax = true;
    package = pkgs.ghostty-bin;
    settings = my_settings;
  };
}
