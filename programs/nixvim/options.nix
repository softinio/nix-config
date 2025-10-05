{ ... }:

{
  programs.nixvim = {

    clipboard = {
      register = "unnamedplus";
    };

    opts = {
      backup = false;
      breakindent = true;
      expandtab = true;
      hlsearch = true;
      incsearch = true;
      mouse = "a";
      number = true;
      relativenumber = true;
      scrolloff = 8;
      shiftwidth = 2;
      signcolumn = "auto";
      smartindent = true;
      swapfile = false;
      tabstop = 2;
      termguicolors = true;
      undofile = true;
      updatetime = 100;
      wrap = false;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
  };
}
