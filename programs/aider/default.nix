{ lib, pkgs, ... }:

let
  aiderConfig = builtins.readFile ./aider.yml;
  aiderPkgs = import ./aider-deriv.nix { inherit lib pkgs; };
in
{
  home.packages = [
    aiderPkgs.withPlaywright
  ];
  home.file.".aider.conf.yml".text = aiderConfig;
}
