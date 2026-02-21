{ user, lib, ... }:

let
  # Set to true to install wezterm via nix, false to only manage config
  useNixPackage = false;

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

  weztermConfigRaw = builtins.readFile ./wezterm.lua;
  weztermConfig = builtins.replaceStrings
    [
      "  -- WEZTERM_SSH_DOMAINS\n"
      "        -- WEZTERM_WORKSPACES\n"
    ]
    [
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
