{ pkgs, theme, ... }:

let
  myExtensions = with pkgs.vscode-extensions; [
    anweber.vscode-httpyac
    baccata.scaladex-search
    charliermarsh.ruff
    davidanson.vscode-markdownlint
    github.copilot
    github.github-vscode-theme
    github.vscode-github-actions
    github.vscode-pull-request-github
    jnoortheen.nix-ide
    marp-team.marp-vscode
    mechatroner.rainbow-csv
    mkhl.direnv
    ms-python.debugpy
    ms-python.python
    ms-python.vscode-pylance
    ms-vscode.makefile-tools
    redhat.java
    redhat.vscode-yaml
    scala-lang.scala
    scalameta.metals
    skyapps.fish-vscode
    svsool.markdown-memo
    timonwong.shellcheck
    usernamehw.errorlens
    visualjj.visualjj
    vscode-icons-team.vscode-icons
    vscodevim.vim
    yzhang.markdown-all-in-one
    ziglang.vscode-zig
  ];

  # sswg.swift-lang is deprecated upstream in favour of swiftlang.swift-vscode,
  # which nixpkgs does not package yet. Pinned from the marketplace so the
  # extension set stays declarative; bump version + hash by hand.
  marketplaceExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "swift-vscode";
      publisher = "swiftlang";
      version = "2.17.20260904";
      sha256 = "sha256-WjED0RnCXDzaTA+SKpHkf9nMEeOLPKsW+4lshziqMH4=";
    }
  ];
  myUserSettings = {
    "editor.fontFamily" = theme.fontFamily;
    "editor.fontLigatures" = true;
    "editor.fontSize" = 13;
    # VS Code can otherwise update the nix-installed extensions in place,
    # drifting from what this file declares. extensions.autoCheckUpdates is
    # set to false by enableExtensionUpdateCheck below.
    "extensions.autoUpdate" = "off";
    "extensions.ignoreRecommendations" = true;
    "files.autoSave" = "afterDelay";
    "files.watcherExclude" = {
      "**/.bloop/**" = true;
      "**/.metals/**/*.{java,scala}" = true;
      "**/node_modules/**" = true;
      "**/target/**" = true;
    };
    "git.confirmSync" = false;
    "git.rebaseWhenSync" = true;
    "github.gitProtocol" = "ssh";
    "githubPullRequests.notifications" = "pullRequests";
    "githubPullRequests.pullBranch" = "never";
    "markdown.extension.preview.autoShowPreviewToSide" = true;
    "metals.startMcpServer" = true;
    "nix.enableLanguageServer" = true;
    # The built-in npm extension otherwise queries the registry on hover.
    "npm.fetchOnlinePackageInfo" = false;
    # Install paste image manually as not in nix ( https://marketplace.visualstudio.com/items?itemName=mushan.vscode-paste-image )
    "pasteImage.insertPattern" = "![[\${imageFileName}]]";
    "pasteImage.path" = "\${projectRoot}/Attachments";
    "python.analysis.extraPaths" = [ "src" ];
    "python.analysis.autoFormatStrings" = true;
    "python.analysis.autoImportCompletions" = true;
    "python.analysis.completeFunctionParens" = true;
    "python.analysis.inlayHints.pytestParameters" = true;
    "python.analysis.typeCheckingMode" = "strict";
    "python.testing.pytestEnabled" = true;
    "[python]" = {
      "editor.defaultFormatter" = "charliermarsh.ruff";
      "editor.formatOnSave" = true;
      "editor.codeActionsOnSave" = {
        "source.fixAll" = "always";
        "source.organizeImports" = "always";
      };
    };
    "[scala]" = {
      "editor.defaultFormatter" = "scalameta.metals";
      "editor.formatOnSave" = true;
    };
    # Red Hat extensions ignore telemetry.telemetryLevel and prompt unless
    # their own flag is set.
    "redhat.telemetry.enabled" = false;
    # Also covers the deprecated telemetry.enableTelemetry and
    # telemetry.enableCrashReporter, which this supersedes.
    "telemetry.telemetryLevel" = "off";
    # Surveys and feedback prompts phone home independently of the level above.
    "telemetry.feedback.enabled" = false;
    "terminal.integrated.defaultProfile.osx" = "fish";
    "terminal.integrated.fontFamily" = theme.fontFamily;
    "terminal.integrated.fontLigatures.enabled" = true;
    "terminal.integrated.fontSize" = 13;
    # Mirrors enableUpdateCheck below; the store-installed VS Code cannot
    # update itself anyway, this just stops the checks and the nagging.
    "update.mode" = "none";
    "update.showReleaseNotes" = false;
    "vsicons.dontShowNewVersionMessage" = true;
    "window.openFoldersInNewWindow" = "on";
    # Fetches experiment assignments from Microsoft.
    "workbench.enableExperiments" = false;
    # Sends settings-search queries to Microsoft's online service.
    "workbench.settings.enableNaturalLanguageSearch" = false;
    "workbench.colorTheme" = "GitHub Dark Default";
    "workbench.iconTheme" = "vscode-icons";
    "workbench.sideBar.location" = "right";
  };
in
{
  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        extensions = myExtensions ++ marketplaceExtensions;
        userSettings = myUserSettings;
      };
    };
    mutableExtensionsDir = true;
  };
}
