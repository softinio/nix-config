{ config, pkgs, ... }:

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
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
      { plugin = tmuxPlugins.sensible; }
      { plugin = tmuxPlugins.vim-tmux-navigator; }
      { plugin = tmuxPlugins.onedark-theme; }
    ];
  };
}
