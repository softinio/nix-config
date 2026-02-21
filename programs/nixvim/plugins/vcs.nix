{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-signify
    ];
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
