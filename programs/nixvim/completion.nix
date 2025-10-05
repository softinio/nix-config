{ ... }:

{
  programs.nixvim = {
    opts.completeopt = [
      "menu"
      "menuone"
      "noselect"
    ];

    plugins = {
      luasnip.enable = true;

      cmp-buffer.enable = true;
      cmp-cmdline.enable = true;
      cmp-fish.enable = true;
      cmp-git.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-document-symbol.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-nvim-lua.enable = true;
      cmp-path.enable = true;

      lspkind = {
        enable = true;

        settings = {
          cmp = {
            enable = true;
            menu = {
              nvim_lsp = "[LSP]";
              luasnip = "[snip]";
              buffer = "[buffer]";
              path = "[path]";
              nvim_lua = "[api]";
            };
          };
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          performance = {
            debounce = 60;
            throttle = 30;
            fetching_timeout = 200;
          };

          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';

          mapping = {
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };

          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            {
              name = "buffer";
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            }
            { name = "path"; }
            { name = "nvim_lua"; }
            { name = "cmp-nvim-lsp-signature-help"; }
          ];
        };
      };
    };
  };
}
