{ lib, ... }:

{
  programs.nixvim = {
    diagnostic.settings.virtual_text = true;

    lsp = {
      inlayHints.enable = true;
      servers = {
        basedpyright = {
          enable = true;
          settings.settings.basedpyright = {
            analysis = {
              autoImportCompletions = true;
              autoSearchPaths = true;
              inlayHints = {
                callArgumentNames = true;
              };
              diagnosticMode = "openFilesOnly";
              reportMissingImports = true;
              reportMissingParameterType = true;
              reportUnnecessaryComparison = true;
              reportUnnecessaryContains = true;
              reportUnusedClass = true;
              reportUnusedFunction = true;
              reportUnsedImports = true;
              reportUnsusedVariables = true;
              typeCheckingMode = "recommended";
              useLibraryCodeForTypes = true;
            };
          };
        };
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
        rust_analyzer.enable = true;
        sourcekit = {
          enable = true;
          settings = {
            cmd = [
              "xcrun"
              "sourcekit-lsp"
            ];
          };
        };
        tinymist.enable = true;
        ts_ls.enable = true;
        yamlls.enable = true;
      };

      keymaps = [
        {
          key = "<leader>k";
          action.__raw = "function() vim.diagnostic.jump({ count=-1, float=true }) end";
        }
        {
          key = "<leader>j";
          action.__raw = "function() vim.diagnostic.jump({ count=1, float=true }) end";
        }
        {
          key = "gd";
          lspBufAction = "definition";
        }
        {
          key = "gD";
          lspBufAction = "references";
        }
        {
          key = "gt";
          lspBufAction = "type_definition";
        }
        {
          key = "gi";
          lspBufAction = "implementation";
        }
        {
          key = "K";
          lspBufAction = "hover";
        }
        {
          key = "<F2>";
          lspBufAction = "rename";
        }
      ];
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
