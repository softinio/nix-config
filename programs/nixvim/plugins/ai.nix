{ ... }:

{
  programs.nixvim.plugins = {
    # GitHub Copilot
    copilot-vim.enable = true;

    # Avante AI assistant (imported from separate file)
    # avante config is in avante.nix
  };
}