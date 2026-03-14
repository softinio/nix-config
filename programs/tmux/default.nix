{ pkgs, lib, user, ... }:

let
  tmsConfig =
    let
      workspaces = user.weztermWorkspaces or [ ];
      nonEmpty = builtins.filter (w: w.id != "") workspaces;
      depthOf = w:
        let segments = builtins.filter (s: s != "") (lib.splitString "/" w.id);
        in if builtins.length segments == 1 then 1 else 0;
      paths = map (w: "\"~${w.id}\"") nonEmpty;
      depths = map (w: toString (depthOf w)) nonEmpty;
    in
    "search_paths = [${lib.concatStringsSep ", " paths}]\n"
    + "max_depths = [${lib.concatStringsSep ", " depths}]\n";

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

    # panes: window splitting (use current pane directory)
    unbind %
    bind "'" split-window -h -c "#{pane_current_path}"
    unbind '"'
    bind - split-window -v -c "#{pane_current_path}"

    # Switch panes with Dvorak-friendly keys (dhtn)
    bind d select-pane -L
    bind h select-pane -D
    bind t select-pane -U
    bind n select-pane -R

    # Switch windows by number (matching wezterm Leader 1-9)
    bind 1 select-window -t :1
    bind 2 select-window -t :2
    bind 3 select-window -t :3
    bind 4 select-window -t :4
    bind 5 select-window -t :5
    bind 6 select-window -t :6
    bind 7 select-window -t :7
    bind 8 select-window -t :8
    bind 9 select-window -t :9

    # resize panes (Leader + Ctrl + Dvorak navigation)
    bind -r C-d resize-pane -L 10
    bind -r C-h resize-pane -D 10
    bind -r C-t resize-pane -U 10
    bind -r C-n resize-pane -R 10

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
    bind o display-popup -E "tms"

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

  home.file."Library/Application Support/tms/config.toml".text = tmsConfig;
}
