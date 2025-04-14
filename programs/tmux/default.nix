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
        plugin = kanagawa;
        extraConfig = ''
          set -g @kanagawa-theme 'wave'
          set -g @kanagawa-plugins "cpu-usage git"
          set -g @kanagawa-show-powerline true
          set -g @kanagawa-refresh-rate 10

          set -g status-right " #(tms sessions)"
          bind -r '(' switch-client -p\; refresh-client -S
          bind -r ')' switch-client -n\; refresh-client -S
        '';
      }
    ];
  };
}
