local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace())
end)

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
  pane:split { size = 0.2 }
end)

return {
  adjust_window_size_when_changing_font_size = false,
  check_for_updates = false,
  color_scheme = 'Tango (terminal.sexy)',
  default_gui_startup_args = { 'connect', 'unix' },
  font = wezterm.font_with_fallback { 'JetBrains Mono', 'Noto Color Emoji' },
  font_size = 12.0,
  dpi = 144,
  scrollback_lines = 50000,
  initial_cols = 400,
  initial_rows = 80,
  leader = { key = 'b', mods = 'SUPER', timeout_milliseconds = 1000 },
  default_prog = { '/etc/profiles/per-user/salar/bin/fish' },
  window_decorations = 'RESIZE',
  ssh_domains = {
    {
      name = 'hcloud1',
      remote_address = 'hcloud1.softinio.net',
      username = 'salar',
      remote_wezterm_path = '/run/current-system/sw/bin/wezterm',
    },
  },
  unix_domains = {
    {
      name = 'unix',
      proxy_command = { 'nc', '-U', '/Users/salar/.local/share/wezterm/sock' },
    },
  },
  keys = {
    { key = '-', mods = 'LEADER', action = wezterm.action { SplitVertical = { domain = 'CurrentPaneDomain' } } },
    { key = "'", mods = 'LEADER', action = wezterm.action { SplitHorizontal = { domain = 'CurrentPaneDomain' } } },
    { key = 'k', mods = 'SUPER', action = act.TogglePaneZoomState },
    { key = 'h', mods = 'LEADER', action = wezterm.action { ActivatePaneDirection = 'Left' } },
    { key = 'j', mods = 'LEADER', action = wezterm.action { ActivatePaneDirection = 'Down' } },
    { key = 'k', mods = 'LEADER', action = wezterm.action { ActivatePaneDirection = 'Up' } },
    { key = 'l', mods = 'LEADER', action = wezterm.action { ActivatePaneDirection = 'Right' } },
    { key = 'H', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Left', 5 } } },
    { key = 'J', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Down', 5 } } },
    { key = 'K', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Up', 5 } } },
    { key = 'L', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Right', 5 } } },
    { key = '1', mods = 'LEADER', action = wezterm.action { ActivateTab = 0 } },
    { key = '2', mods = 'LEADER', action = wezterm.action { ActivateTab = 1 } },
    { key = '3', mods = 'LEADER', action = wezterm.action { ActivateTab = 2 } },
    { key = '4', mods = 'LEADER', action = wezterm.action { ActivateTab = 3 } },
    { key = '5', mods = 'LEADER', action = wezterm.action { ActivateTab = 4 } },
    { key = '6', mods = 'LEADER', action = wezterm.action { ActivateTab = 5 } },
    { key = '7', mods = 'LEADER', action = wezterm.action { ActivateTab = 6 } },
    { key = '8', mods = 'LEADER', action = wezterm.action { ActivateTab = 7 } },
    { key = '9', mods = 'LEADER', action = wezterm.action { ActivateTab = 8 } },
    { key = '&', mods = 'LEADER', action = wezterm.action { CloseCurrentTab = { confirm = true } } },
    { key = 'x', mods = 'LEADER', action = wezterm.action { CloseCurrentPane = { confirm = true } } },
    { key = 'Enter', mods = 'ALT', action = act.DisableDefaultAssignment },
    { key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },
    { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
    { key = 'n', mods = 'SUPER', action = act.SpawnWindow },
    { key = 't', mods = 'SUPER', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'h', mods = 'SUPER', action = act { SpawnCommandInNewTab = { cwd = wezterm.home_dir } } },
    { key = 'q', mods = 'SUPER', action = act.QuitApplication },
    { key = 'i', mods = 'CTRL|SHIFT', action = act.SwitchToWorkspace },
    {
      key = '8',
      mods = 'ALT',
      action = wezterm.action_callback(function(window, pane)
        -- Here you can dynamically construct a longer list if needed

        local home = wezterm.home_dir
        local workspaces = {
          { id = home, label = 'Home' },
          { id = home .. '/Projects', label = 'My Projects' },
          { id = home .. '/OpenSource', label = 'Open Source Projects' },
          { id = home .. '/.config/nixpkgs', label = 'Nix Config' },
          { id = home .. '/Projects/scalanews', label = 'Scala News' },
        }

        window:perform_action(
          act.InputSelector {
            action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
              if not id and not label then
                wezterm.log_info 'cancelled'
              else
                wezterm.log_info('id = ' .. id)
                wezterm.log_info('label = ' .. label)
                inner_window:perform_action(
                  act.SwitchToWorkspace {
                    name = label,
                    spawn = {
                      label = 'Workspace: ' .. label,
                      cwd = id,
                    },
                  },
                  inner_pane
                )
              end
            end),
            title = 'Choose Workspace',
            choices = workspaces,
            fuzzy = true,
            fuzzy_description = 'Fuzzy find and/or make a workspace',
          },
          pane
        )
      end),
    },
    {
      key = '9',
      mods = 'ALT',
      action = act.ShowLauncherArgs {
        flags = 'FUZZY|WORKSPACES',
      },
    },
    { key = 'Tab', mods = 'CTRL', action = wezterm.action.DisableDefaultAssignment },
  },
}
