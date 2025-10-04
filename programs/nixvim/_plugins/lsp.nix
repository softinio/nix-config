{ lib, ... }:

{
  programs.nixvim = {
    diagnostic.settings.virtual_text = true;

    lsp = {
      inlayHints.enable = true;
      servers = {
        bashls.enable = true;
        html.enable = true;
        jqls.enable = true;
        jsonls.enable = true;
        lua_ls = {
          enable = true;
          settings.settings.diagnostics.globals = [ "vim" ];
        };
        marksman.enable = true;
        metals.enable = true;
        nil_ls.enable = true;
        nixd.enable = true;
        pyrefly.enable = true;
        rust_analyzer.enable = true;
        sourcekit.enable = true;
        ts_ls.enable = true;
        yamlls.enable = true;
      };

      keymaps =
        lib.mapAttrsToList
          (
            key: props:
            {
              inherit key;
              options.silent = true;
            }
            // props
          )
          {
            "<leader>k".action.__raw = "function() vim.diagnostic.jump({ count=-1, float=true }) end";
            "<leader>j".action.__raw = "function() vim.diagnostic.jump({ count=1, float=true }) end";
            gd.lspBufAction = "definition";
            gD.lspBufAction = "references";
            gt.lspBufAction = "type_definition";
            gi.lspBufAction = "implementation";
            K.lspBufAction = "hover";
            "<F2>".lspBufAction = "rename";
          };
    };

    plugins = {
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };

      # Sane defaults for all servers
      lspconfig.enable = true;
    };
  };
}
