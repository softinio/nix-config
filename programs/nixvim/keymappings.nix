{ lib, ... }:

{
  programs.nixvim = {
    keymaps =
      let
        normal =
          lib.mapAttrsToList
            (
              key: action: {
                mode = "n";
                inherit action key;
              }
            )
            {
              "<Space>" = "<NOP>";
              "<esc>" = ":noh<CR>";
              "Y" = "y$";
              "<C-c>" = ":b#<CR>";
              "<C-x>" = ":close<CR>";
              "<leader>s" = ":w<CR>";
              "<C-s>" = ":w<CR>";
              "<leader>h" = "<C-w>h";
              "<leader>l" = "<C-w>l";
              "L" = "$";
              "H" = "^";
              "<C-Up>" = ":resize -2<CR>";
              "<C-Down>" = ":resize +2<CR>";
              "<C-Left>" = ":vertical resize +2<CR>";
              "<C-Right>" = ":vertical resize -2<CR>";
              "<M-k>" = ":move-2<CR>";
              "<M-j>" = ":move+<CR>";
            };
        visual =
          lib.mapAttrsToList
            (
              key: action: {
                mode = "v";
                inherit action key;
              }
            )
            {
              ">" = ">gv";
              "<" = "<gv";
              "<TAB>" = ">gv";
              "<S-TAB>" = "<gv";
              "K" = ":m '<-2<CR>gv=gv";
              "J" = ":m '>+1<CR>gv=gv";
            };
      in
      normal ++ visual;
  };
}
