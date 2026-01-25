{ ... }:

{
  imports = [
    # Core plugin categories
    ./ui.nix
    ./git.nix
    ./editing.nix
    ./utility.nix
    ./ai.nix

    # LSP configuration
    ./lsp

    # Language-specific configurations
    ./scala.nix

    # Individual plugin configurations
    ./avante.nix
    ./conform.nix
    ./floaterm.nix
    ./lualine.nix
    ./neo-tree.nix
    ./telescope.nix
    ./treesitter.nix
  ];
}