{ ... }:

{
  programs.nixvim.lsp = {
    inlayHints.enable = true;

    servers = {
      # Python
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

      # Shell scripting
      bashls.enable = true;

      # Web development
      html.enable = true;
      jsonls.enable = true;
      yamlls.enable = true;
      ts_ls.enable = true;

      # Query languages
      jqls.enable = true;

      # Lua
      lua_ls = {
        enable = true;
        settings.settings.diagnostics.globals = [ "vim" ];
      };

      # Documentation
      marksman.enable = true;

      # Scala
      metals.enable = true;

      # Nix
      nil_ls.enable = true;
      nixd.enable = true;

      # Rust
      rust_analyzer.enable = true;

      # Swift/iOS development
      sourcekit = {
        enable = true;
        settings = {
          cmd = [
            "xcrun"
            "sourcekit-lsp"
          ];
        };
      };

      # Typst
      tinymist.enable = true;
    };
  };
}