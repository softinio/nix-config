{ pkgs, ... }:

let
  myExtensions = with pkgs.vscode-extensions; [
    asvetliakov.vscode-neovim
    baccata.scaladex-search
    charliermarsh.ruff
    davidanson.vscode-markdownlint
    enkia.tokyo-night
    github.copilot
    github.copilot-chat
    github.github-vscode-theme
    github.vscode-github-actions
    github.vscode-pull-request-github
    humao.rest-client
    jnoortheen.nix-ide
    marp-team.marp-vscode
    mechatroner.rainbow-csv
    mkhl.direnv
    ms-python.debugpy
    ms-python.python
    ms-python.vscode-pylance
    ms-toolsai.jupyter
    ms-toolsai.jupyter-keymap
    ms-toolsai.jupyter-renderers
    ms-toolsai.vscode-jupyter-cell-tags
    ms-toolsai.vscode-jupyter-slideshow
    ms-vscode.makefile-tools
    ms-toolsai.jupyter
    redhat.java
    redhat.vscode-yaml
    rust-lang.rust-analyzer
    scalameta.metals
    skyapps.fish-vscode
    sswg.swift-lang
    svsool.markdown-memo
    timonwong.shellcheck
    usernamehw.errorlens
    visualstudioexptteam.vscodeintellicode
    visualjj.visualjj
    vscode-icons-team.vscode-icons
    vscjava.vscode-java-pack
    xyz.local-history
    yzhang.markdown-all-in-one
  ];
  myUserSettings = {
    "editor.fontFamily" = "SF Mono";
    "editor.fontLigatures" = true;
    "editor.fontSize" = 13;
    "editor.copyWithSyntaxHighlighting" = true;
    "extensions.experimental.affinity" = {
      "asvetliakov.vscode-neovim" = 1;
    };
    "extensions.ignoreRecommendations" = true;
    "files.autoSave" = "afterDelay";
    "git.confirmSync" = true;
    "git.rebaseWhenSync" = true;
    "github.gitProtocol" = "ssh";
    "githubPullRequests.notifications" = "pullRequests";
    "githubPullRequests.pullBranch" = "never";
    "markdown.extension.preview.autoShowPreviewToSide" = true;
    "notebook.formatOnSave" = true;
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
        "source.fixAll" = true;
        "source.organizeImports" = true;
      };
    };
    "telemetry.telemetryLevel" = "off";
    "terminal.integrated.defaultProfile.osx" = "fish";
    "terminal.integrated.fontFamily" = "SF Mono";
    "terminal.integrated.fontSize" = 13;
    "update.mode" = "none";
    "vsicons.dontShowNewVersionMessage" = true;
    "window.openFoldersInNewWindow" = "on";
    "workbench.colorTheme" = "Tokyo Night";
    "workbench.iconTheme" = "vscode-icons";
    "workbench.sideBar.location" = "right";
  };
in
{
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = myExtensions;
    userSettings = myUserSettings;
  };
}
