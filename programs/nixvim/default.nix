{ ... }:

{
  imports = [
    ./autocommands.nix
    ./completion.nix
    ./keymappings.nix
    ./options.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;

    defaultEditor = true;

    nixpkgs.useGlobalPackages = true;

    viAlias = true;
    vimAlias = true;
  };
}
