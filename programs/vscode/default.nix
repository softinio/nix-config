{ config, pkgs, ... }:

let
  myExtensions = with pkgs.vscode-extensions; [
    asvetliakov.vscode-neovim
    baccata.scaladex-search
    davidanson.vscode-markdownlint
    enkia.tokyo-night
    github.copilot
    github.copilot-chat
    github.github-vscode-theme
    github.vscode-github-actions
    github.vscode-pull-request-github
    humao.rest-client
    jnoortheen.nix-ide
    mechatroner.rainbow-csv
    mkhl.direnv
    ms-python.python
    ms-python.vscode-pylance
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
    "files.autoSave" = "afterDelay";
    "git.autoSave" = "afterDelay";
    "git.rebaseWhenSync" = true;
    "github.gitProtocol" = "ssh";
    "githubPullRequests.notifications" = "pullRequests";
    "githubPullRequests.pullBranch" = "never";
    "markdown.extension.preview.autoShowPreviewToSide" = true;
    # Install paste image manually as not in nix ( https://marketplace.visualstudio.com/items?itemName=mushan.vscode-paste-image )
    "pasteImage.insertPattern" = "![[\${imageFileName}]]";
    "pasteImage.path" = "\${projectRoot}/Attachments";
    "python.analysis.extraPaths" = [ "src" ];
    "telemetry.telemetryLevel" = "off";
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
