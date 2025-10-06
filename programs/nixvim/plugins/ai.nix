{ pkgs, lib, ... }:

{
  programs.nixvim = {
    plugins = {
      # GitHub Copilot
      copilot-vim.enable = true;

      # Avante AI assistant (imported from separate file)
      # avante config is in avante.nix
    };

    globals = {
      copilot_node_command = lib.mkForce "${pkgs.nodejs-slim}/bin/node";
    };
  };
}