{ ... }:

{
  programs.nixvim = {
    opts.completeopt = [
      "menu"
      "menuone"
      "noselect"
      "popup"
    ];

    # Native LSP completion (Neovim 0.12+)
    opts.autocomplete = true;
  };
}
