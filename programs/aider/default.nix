{ pkgs, ... }:

let
  aiderConfig = builtins.readFile ./aider.yml;
in
{
  home.packages = with pkgs; [
    aider-chat.withPlaywright
  ];
  home.file.".aider.conf.yml".text = aiderConfig;
}
