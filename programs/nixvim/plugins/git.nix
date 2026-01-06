{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-signify
    ];
    plugins = {
      # Git signs in the gutter
      gitsigns = {
        enable = false;
        settings.signs = {
          add.text = "+";
          change.text = "~";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
        };
      };
    };

    # vim-signify color customization
    highlight = {
      SignifySignAdd = {
        fg = "#00ff00";
        ctermfg = "green";
      };
      SignifySignDelete = {
        fg = "#ff0000";
        ctermfg = "red";
      };
      SignifySignChange = {
        fg = "#ffff00";
        ctermfg = "yellow";
      };
    };
  };
}
