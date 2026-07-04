{
  inputs,
  lib,
  ...
}:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Shared appearance settings available to every module as `theme`.
  _module.args.theme = import ./theme.nix;

  imports = [
    inputs.hunk.homeManagerModules.default
    inputs.nixvim.homeModules.nixvim
    ./local-options.nix
    ./nix-apps-activation.nix
    ./packages.nix
  ]
  ++ (import ./programs);

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "copilot.vim"
      "copilot-language-server"
      "discord"
      "github-copilot-cli"
      "ijhttp"
      "slack"
      "vscode"
      "vscode-extension-github-copilot"
      "vscode-extension-github-copilot-chat"
      "vscode-extension-MS-python-vscode-pylance"
      "vscode-extension-visualjj-visualjj"
    ];

  home = {
    stateVersion = "26.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
