{ pkgs, ... }:

let
  actionsConfig = builtins.readFile ./open-actions.conf;
in
{
  programs.kitty = {
    enable = true;
    keybindings = {
      "kitty_mod+enter" = "new_window_with_cwd";
      "f1" = "create_marker";
      "f2" = "remove_marker";
      "ctrl+p" = "scroll_to_mark prev";
      "ctrl+n" = "scroll_to_mark next";
    };
    themeFile = "Tango_Dark";
    font = {
      name = "SF Mono";
      size = 13;
    };
    settings = {
      active_tab_background = "#FF0";
      copy_on_select = true;
      enabled_layouts = "Tall,*";
      kitty_mod = "cmd+option";
      macos_quit_when_last_window_closed = true;
      scrollback_lines = 100000;
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
    shellIntegration.enableFishIntegration = true;
  };

  home.file.".config/kitty/open-actions.conf".text = actionsConfig;
}
