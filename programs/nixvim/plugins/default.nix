{ ... }:

{
  imports = [
    # Core plugin categories
    ./ai.nix
    ./editing.nix
    ./ui.nix
    ./utility.nix
    ./vcs.nix

    # LSP configuration
    ./lsp

    # Language-specific configurations
    ./scala.nix

    # Individual plugin configurations
    ./avante.nix
    ./conform.nix
    ./floaterm.nix
    ./lualine.nix
    ./snacks.nix
    ./treesitter.nix
  ];
}
