{ ... }:

{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>m";
        action.__raw = ''
          function()
            local has_file = vim.fn.expand('%:p') ~= ""
            require("neo-tree.command").execute({
              action = "focus",
              reveal = has_file,
              toggle = true,
            })
          end
        '';
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
