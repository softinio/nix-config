{ pkgs, ... }:

let
  tmuxConfig = ''
    # disable mouse
    set -g mouse off

    # increase repeat time for repeatable commands
    set -g repeat-time 1000

    # highlight window when it has new activity
    setw -g monitor-activity on
    set -g visual-activity on

    # re-number windows when one is closed
    set -g renumber-windows on

    ###########################
    #  Key Bindings
    ###########################

    # Copy vim style
    # create 'v' alias for selecting text
    bind Escape copy-mode
    bind C-[ copy-mode
    bind -T copy-mode-vi 'v' send -X begin-selection
    # copy with 'enter' or 'y' and send to mac os clipboard
    unbind -T copy-mode-vi Enter
    bind -T copy-mode-vi Enter send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
    bind -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
    # paste
    bind p paste-buffer

    # panes: window splitting
    unbind %
    bind "'" split-window -h
    unbind '"'
    bind - split-window -v

    # Switch panes with Dvorak-friendly keys (dhtn)
    bind d select-pane -L
    bind h select-pane -D
    bind t select-pane -U
    bind n select-pane -R

    # Quick window selection (Dvorak-friendly)
    bind -r C-d select-window -t :-
    bind -r C-n select-window -t :+

    # resize panes (Ctrl + Dvorak navigation to avoid conflicts with neovim)
    bind -r C-Left resize-pane -L 10
    bind -r C-Down resize-pane -D 10
    bind -r C-Up resize-pane -U 10
    bind -r C-Right resize-pane -R 10

    # Quickly switch panes (using Dvorak 'h' for down)
    unbind ^H
    bind ^H select-pane -t :.+

    ############################
    ## Status Bar
    ############################

    # enable UTF-8 support in status bar
    set -gq status-utf8 on

    # center the status bar
    set -g status-justify centre

    # show session, window, pane in left status bar
    set -g status-left-length 40
    set -g status-left '#[fg=green] #S #[fg=yellow]#I/#[fg=cyan]#P '

    # update status bar info
    set -g status-interval 60

    set -g status-right " #(tms sessions)"
    bind -r '(' switch-client -p\; refresh-client -S
    bind -r ')' switch-client -n\; refresh-client -S
    bind C-o display-popup -E "tms"

    set -g default-command /etc/profiles/per-user/salar/bin/fish
  '';
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    resizeAmount = 10;
    escapeTime = 10;
    historyLimit = 10000;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "xterm-256color";
    extraConfig = tmuxConfig;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      tokyo-night-tmux
      yank
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
