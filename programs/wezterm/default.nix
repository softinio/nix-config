{ user, lib, ... }:

let
  # Set to true to install wezterm via nix, false to only manage config
  useNixPackage = false;

  # Set to true to enable the unix-domain multiplexer on startup
  useMux = false;

  sshDomainToLua = d:
    "    {\n"
    + "      name = '${d.name}',\n"
    + "      remote_address = '${d.remoteAddress}',\n"
    + "      username = '${d.username}',\n"
    + "      remote_wezterm_path = '${d.remoteWeztermPath}',\n"
    + "    },\n";

  sshDomainsBlock =
    let
      domains = user.weztermSshDomains or [ ];
    in
    if domains == [ ] then
      ""
    else
      "  ssh_domains = {\n" + lib.concatMapStrings sshDomainToLua domains + "  },\n";

  workspaceToLua = w:
    if w.id == "" then
      "          { id = home, label = '${w.label}' },\n"
    else
      "          { id = home .. '${w.id}', label = '${w.label}' },\n";

  workspacesLua =
    let
      ws = user.weztermWorkspaces or [ ];
    in
    if ws == [ ] then
      "        local workspaces = {}\n"
    else
      "        local workspaces = {\n"
      + lib.concatMapStrings workspaceToLua ws
      + "        }\n";

  muxHandlers = if useMux then ''
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  pane:split { size = 0.2 }
end)

wezterm.on('gui-attached', function(domain)
  local workspace = mux.get_active_workspace()
  for _, window in ipairs(mux.all_windows()) do
    if window:get_workspace() == workspace then
      window:gui_window():maximize()
    end
  end
end)
'' else "";

  muxStartupArgs = if useMux then "  default_gui_startup_args = { 'connect', 'unix' },\n" else "";

  muxDomains = if useMux then ''
  unix_domains = {
    {
      name = 'unix',
    },
  },
'' else "";

  weztermConfigRaw = builtins.readFile ./wezterm.lua;
  weztermConfig = builtins.replaceStrings
    [
      "-- WEZTERM_MUX_HANDLERS\n"
      "  -- WEZTERM_MUX_STARTUP_ARGS\n"
      "  -- WEZTERM_MUX_DOMAINS\n"
      "  -- WEZTERM_SSH_DOMAINS\n"
      "        -- WEZTERM_WORKSPACES\n"
    ]
    [
      muxHandlers
      muxStartupArgs
      muxDomains
      sshDomainsBlock
      workspacesLua
    ]
    weztermConfigRaw;
in
{
  programs.wezterm = {
    enable = useNixPackage;
    extraConfig = weztermConfig;
  };

  # When not using nix package, just place the config file
  xdg.configFile."wezterm/wezterm.lua" = {
    enable = !useNixPackage;
    text = weztermConfig;
  };
}
