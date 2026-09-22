{ pkgs, theme, ... }:
let
  my_settings = {
    auto-update = "off";
    copy-on-select = "clipboard";
    font-family = theme.fontFamily;
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
      # macOS keeps Cmd chords out of the pty, so herdr never sees cmd+r on its own.
      # Relay it as F12 (CSI 24~) instead; herdr binds f12 to the reviewr toggle.
      "super+r=csi:24~"
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
