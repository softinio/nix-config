{ ... }:

{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      extensions = {
        file-browser = {
          enable = true;
          settings = {
            auto_depth = true;
            hijack_netrw = true;
            mappings = {
              i = {
                "<A-S-CR>".__raw = "require('telescope').extensions.file_browser.actions.create_from_prompt";
              };
            };
            prompt_path = true;
          };
        };
        fzf-native.enable = true;
        ui-select.enable = true;
        undo.enable = true;
      };

      keymaps = {
        "<leader>fb" = "file_browser";
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>b" = "buffers";
        "<leader>fh" = "help_tags";
        "<leader>fd" = "diagnostics";

        "<C-p>" = "git_files";
        "<leader>?" = "oldfiles";
      };

      settings.defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        set_env.COLORTERM = "truecolor";
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<C-t>";
        action.__raw = ''
          function()
            require('telescope.builtin').live_grep({
              default_text="TODO",
              initial_mode="normal"
            })
          end
        '';
        options.silent = true;
      }
    ];
  };
}
