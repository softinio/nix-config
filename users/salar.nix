{
  username = "salar";
  fullName = "Salar Rahmanian";
  email = "code@softinio.com";
  gitSigningKey = "~/.ssh/id_ed25519.pub";
  jujutsuBranchPrefix = "softinio";
  weztermSshDomains = [
    {
      name = "hcloud1";
      remoteAddress = "hcloud1.softinio.net";
      username = "salar";
      remoteWeztermPath = "/run/current-system/sw/bin/wezterm";
    }
  ];
  weztermWorkspaces = [
    {
      id = "";
      label = "Home";
    }
    {
      id = "/Projects";
      label = "My Projects";
    }
    {
      id = "/OpenSource";
      label = "Open Source Projects";
    }
    {
      id = "/.config/nixpkgs";
      label = "Nix Config";
    }
    {
      id = "/Projects/scalanews";
      label = "Scala News";
    }
  ];
}
