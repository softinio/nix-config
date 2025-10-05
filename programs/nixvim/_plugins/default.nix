{ ... }:

{
  imports = [
    ./avante.nix
    ./conform.nix
    ./floaterm.nix
    ./lsp.nix
    ./lualine.nix
    ./neo-tree.nix
    ./telescope.nix
    ./treesitter.nix
  ];

  # Global plugin configurations can go here
  programs.nixvim = {
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "night";
        on_colors.__raw = "function(colors) colors.bg = \"#000000\" end";
      };
    };

    plugins = {
      # Lazy loading
      lz-n.enable = true;

      web-devicons.enable = true;

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "+";
          change.text = "~";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
        };
      };

      nvim-autopairs.enable = true;

      colorizer = {
        enable = true;
        settings.user_default_options.names = false;
      };

      copilot-vim.enable = true;

      fidget.enable = true;

      flash.enable = true;

      img-clip = {
        enable = true;
        settings = {
          default = {
            embed_image_as_base64 = false;
            prompt_for_file_name = false;
            drag_and_drop = {
              insert_mode = true;
            };
            use_absolute_path = true;
          };
        };
      };

      indent-blankline.enable = true;

      markview.enable = true;

      nui.enable = true;

      oil = {
        enable = true;
        lazyLoad.settings.cmd = "Oil";
      };

      snacks.enable = true;

      todo-comments = {
        enable = true;
        keymaps.todoTelescope.key = "<leader>t";
      };

      trim = {
        enable = true;
        settings = {
          highlight = true;
          ft_blocklist = [
            "checkhealth"
            "floaterm"
            "lspinfo"
            "neo-tree"
            "TelescopePrompt"
          ];
        };
      };

      trouble.enable = true;
      typst-preview.enable = true;
      which-key.enable = true;
    };
  };
}
