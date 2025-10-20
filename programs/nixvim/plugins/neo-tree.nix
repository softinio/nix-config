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

      settings = {
        close_if_last_window = true;
        filesystem.filtered_items.visible = true;
        window = {
          width = 30;
          autoExpandWidth = true;
          position = "right";
        };
      };
    };
  };
}
