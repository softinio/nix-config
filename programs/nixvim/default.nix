{ pkgs, ... }:

{
  imports = [
    ./options.nix
    ./keymappings.nix
    ./completion.nix
    ./_plugins
  ];

  programs.nixvim = {
    enable = true;

    defaultEditor = true;

    nixpkgs.useGlobalPackages = true;

    viAlias = true;
    vimAlias = true;
  };
}
