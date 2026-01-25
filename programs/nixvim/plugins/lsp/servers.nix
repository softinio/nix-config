{ ... }:

{
  programs.nixvim.lsp = {
    inlayHints.enable = true;

    servers = {
      # Python
      basedpyright = {
        enable = false;
        config.settings.basedpyright = {
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
      ts_ls.enable = true;
      yamlls.enable = true;

      # Query languages
      jqls.enable = true;

      # Lua
      lua_ls = {
        enable = true;
        config.settings.diagnostics.globals = [ "vim" ];
      };

      # Documentation
      marksman.enable = true;

      # Scala
      metals = {
        enable = true;
        config = {
          filetypes = [
            "scala"
            "sbt"
            "sc"
            "mill"
          ];
          settings.metals = {
            # Build tool settings
            defaultBspToBuildTool = true;
            bloopVersion = "latest.release";

            # Shell and execution
            defaultShell = "fish";

            # Features
            enableBestEffort = true;
            enableSemanticHighlighting = true;
            testUserInterface = "Test Explorer";

            # Excluded packages (Java APIs we don't want)
            excludedPackages = [
              "akka.actor.typed.javadsl"
              "com.github.swagger.akka.javadsl"
            ];

            # Status bar integration
            initOptions = {
              statusBarProvider = "on";
              compilerOptions = {
                snippetAutoIndent = false;
              };
            };

            # Inlay hints for better code understanding
            inlayHints = {
              typeParameters.enable = true;
              hintsInPatternMatch.enable = true;
              inferredTypes.enable = true;
              implicitArguments.enable = true;
              implicitConversions.enable = true;
            };

            # Claude integration
            mcpClient = "claude";
            startMcpServer = true;

            # Server version
            serverVersion = "latest.snapshot";

            # Display options
            showImplicitArguments = true;
            showImplicitConversionsAndClasses = true;
            showInferredType = true;

            # Code lens features
            superMethodLensesEnabled = true;

            # Use globally installed metals
            useGlobalExecutable = true;
          };
        };
      };

      # Nix
      nil_ls.enable = true;
      nixd.enable = true;

      # Python Pyrefly
      pyrefly.enable = true;

      # Rust
      rust_analyzer.enable = true;

      # Swift/iOS development
      sourcekit = {
        enable = true;
        config = {
          cmd = [
            "xcrun"
            "sourcekit-lsp"
          ];
        };
      };

      # Typst
      tinymist.enable = true;

      # Zig Lang
      zls.enable = true;
    };
  };
}
