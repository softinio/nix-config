{ pkgs, ... }:

let
  tmuxConfig = builtins.readFile ./tmux.conf;
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 10;
    historyLimit = 10000;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "xterm-256color";
    extraConfig = tmuxConfig;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      kanagawa
      {
        plugin = tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-tmux_theme night
          set -g @tokyo-night-tmux_transparent 1
          set -g @tokyo-night-tmux_terminal_icon 
          set -g @tokyo-night-tmux_active_terminal_icon 

          set -g @tokyo-night-tmux_show_path 1
          set -g @tokyo-night-tmux_path_format full

          # No extra spaces between icons
          set -g @tokyo-night-tmux_window_tidy_icons 0

          set -g status-right " #(tms sessions)"
          bind -r '(' switch-client -p\; refresh-client -S
          bind -r ')' switch-client -n\; refresh-client -S
          bind C-o display-popup -E "tms"
        '';
      }
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
  };
}
