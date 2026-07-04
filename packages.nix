# User packages, grouped by domain. Imported by home.nix.
{ pkgs, ... }:

let
  languages = with pkgs; [
    deno
    go
    luajit
    nodejs
    python3Packages.huggingface-hub
    python3Packages.jupyterlab
    rustup
    typescript
    zig
    # Scala / JVM toolchain
    bloop
    coursier
    maven
    metals
    sbt
    scala-cli
    scalafmt
  ];

  languageServers = with pkgs; [
    bash-language-server
    jq-lsp
    lua-language-server
    mypy
    nil
    nixd
    pyrefly
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
    zls
  ];

  formatters = with pkgs; [
    nixfmt
    prettier
    shellcheck
    stylua
  ];

  vcs = with pkgs; [
    gg-jj
    jjui
    lazyjj
    pijul
    tig
  ];

  buildTools = with pkgs; [
    cmake
    niv
    nix-prefetch-git
  ];

  httpTools = with pkgs; [
    httpyac
    ijhttp
  ];

  docsAndMedia = with pkgs; [
    ffmpeg
    ghostscript
    graphviz
    imagemagick
    marp-cli
    mermaid-cli
    multimarkdown
    pandoc
    slides
    tectonic-unwrapped
    typst
  ];

  cliTools = with pkgs; [
    any-nix-shell
    aspell
    cachix
    colordiff
    curlFull
    devenv
    difftastic
    dua
    fd
    github-copilot-cli
    gnupg
    grpcurl
    openssl
    patchelf
    pngpaste
    prettyping
    rclone
    readline
    slumber
    sqlite
    tealdeer
    tmux-sessionizer
    tokei
    tree
    tree-sitter
    wget
    xz
    yq
  ];

  fonts = with pkgs; [
    font-awesome
  ];

  apps = with pkgs; [
    discord
    slack
  ];
in
{
  home.packages =
    languages
    ++ languageServers
    ++ formatters
    ++ vcs
    ++ buildTools
    ++ httpTools
    ++ docsAndMedia
    ++ cliTools
    ++ fonts
    ++ apps;
}
