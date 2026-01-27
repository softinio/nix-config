{ pkgs, ... }:
let
  my_settings = {
    auto-update = "off";
    copy-on-select = "clipboard";
    font-family = "SF Mono";
    font-size = 16;
    link-previews = true;
    macos-icon = "retro";
    macos-shortcuts = "ask";
    macos-titlebar-style = "transparent";
    maximize = true;
    mouse-hide-while-typing = true;
    split-divider-color = "orange";
    theme = "Builtin Tango Dark";
    window-inherit-working-directory = true;
    window-save-state = "always";
    working-directory = "home";
    keybind = [
      "shift+enter=text:\n"
      "super+k=toggle_split_zoom"
      "super+b>'=new_split:right"
      "super+b>-=new_split:down"
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
