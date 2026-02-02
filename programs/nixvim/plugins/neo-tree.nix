{ ... }:

{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>m";
        action = ":Neotree action=focus reveal toggle<CR>";
        options.silent = true;
      }
    ];

    plugins.neo-tree = {
      enable = true;
      lazy = true;

      settings = {
        close_if_last_window = true;
        filesystem.filtered_items = {
          visible = true;
        };
        window = {
          width = 30;
          auto_expand_width = true;
          position = "right";
        };
      };
    };
  };
}
