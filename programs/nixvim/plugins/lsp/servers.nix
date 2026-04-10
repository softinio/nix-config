{ ... }:

{
  programs.nixvim.lsp = {
    inlayHints.enable = true;

    servers = {
      # Shell scripting
      bashls.enable = true;

      # Web development
      html.enable = true;
      jsonls.enable = true;
      ts_ls.enable = true;
      yamlls = {
        enable = true;
        config.filetypes = [ "yaml" "yaml.ansible" ];
      };

      # Query languages
      jqls.enable = true;

      # Lua
      lua_ls = {
        enable = true;
        config.settings.diagnostics.globals = [ "vim" ];
      };

      # Scala
      metals = {
        enable = true;
        config = {
          filetypes = [
            "scala"
            "sbt"
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

      # Python
      # pylsp handles hover, completion, etc. Its formatting/linting plugins
      # (black, isort, flake8) are disabled at runtime when ruff is detected
      # in the project (see autocommands.nix LspAttach handler).
      pylsp = {
        enable = true;
        config.settings.pylsp.plugins = {
          # Formatting / sorting / linting — enabled by default, suppressed
          # at runtime when the project has ruff configured
          black.enabled = true;
          isort.enabled = true;
          flake8.enabled = true;

          # Disable the default pylsp plugins that overlap with the above
          pyflakes.enabled = false;
          pycodestyle.enabled = false;
          autopep8.enabled = false;
          mccabe.enabled = false;
        };
      };
      pyrefly.enable = true;
      ruff.enable = true;

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
