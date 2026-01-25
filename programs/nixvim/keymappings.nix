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
              "<leader>w" = ":w<CR>";
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
              # Metals (Scala) keybindings
              "<leader>mc" = "<cmd>lua require('telescope').extensions.metals.commands()<CR>";
              "<leader>mw" = "<cmd>lua require('metals').hover_worksheet()<CR>";
              "<leader>mt" = "<cmd>lua require('metals.tvp').toggle_tree_view()<CR>";
              "<leader>mr" = "<cmd>lua require('metals.tvp').reveal_in_tree()<CR>";
              "<leader>mi" = "<cmd>lua require('metals').organize_imports()<CR>";
              "<leader>mb" = "<cmd>lua require('metals').build_import()<CR>";
              "<leader>ms" = "<cmd>lua require('metals').super_method_hierarchy()<CR>";
              "<leader>mn" = "<cmd>lua require('metals').new_scala_file()<CR>";
              "<leader>mR" = "<cmd>lua require('metals').build_restart()<CR>";
              "<leader>mC" = "<cmd>lua require('metals').build_connect()<CR>";
              "<leader>md" = "<cmd>lua require('metals').open_all_diagnostics()<CR>";
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
              # Removed gv to allow dot-repeat
              ">" = ">";
              "<" = "<";
              # TAB keeps gv for convenience
              "<TAB>" = ">gv";
              "<S-TAB>" = "<gv";
              "K" = ":m '<-2<CR>gv=gv";
              "J" = ":m '>+1<CR>gv=gv";
            };
      in
      normal ++ visual;
  };
}
