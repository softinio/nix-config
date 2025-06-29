{
  lib,
  pkgs,
  ...
}:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = (import ./programs);

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "gh-copilot"
      "slack"
      "vscode"
      "vscode-extension-github-copilot"
      "vscode-extension-github-copilot-chat"
      "vscode-extension-MS-python-vscode-pylance"
      "vscode-extension-visualjj-visualjj"
    ];

  home = {
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "$EDITOR";
    };
    packages = with pkgs; [
      any-nix-shell
      aspell
      ast-grep
      basedpyright
      bash-language-server
      cachix
      cmake
      coursier
      curlFull
      deno
      devenv
      difftastic
      discord
      dua
      fd
      ffmpeg
      font-awesome
      gnupg
      go
      graphviz
      harlequin
      jetbrains-mono
      jjui
      jq-lsp
      luajit
      lua-language-server
      marksman
      marp-cli
      maven
      meld
      metals
      multimarkdown
      mypy
      neofetch
      neovim
      nerd-fonts.fira-code
      nil
      niv
      nixd
      nix-index
      nixfmt-rfc-style
      nix-prefetch-git
      nodejs
      noto-fonts
      ollama
      openssl
      pandoc
      patchelf
      pngpaste
      prettyping
      pyrefly
      python3Packages.huggingface-hub
      python3Packages.jupyterlab
      rclone
      readline
      ripgrep
      ripgrep-all
      rustup
      sbt
      scala-cli
      shellcheck
      slack
      slides
      slumber
      sqlite
      stylua
      swift-format
      tealdeer
      tectonic
      texlab
      tig
      tmux-sessionizer
      tokei
      tree
      tree-sitter
      typst
      typescript
      typescript-language-server
      wget
      uv
      vscode-langservers-extracted
      xz
      yaml-language-server
      yq
    ];
  };

  programs.bat = {
    enable = true;
  };

  programs.btop = {
    enable = true;
  };

  programs.darcs = {
    enable = true;
    author = [ "Salar Rahmanian <code@softinio.com>" ];
    boring = [
      "^.idea$"
      "^.direnv$"
      "^.envrc$"
      "^.vscode$"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--long"
      "--header"
      "--all"
    ];
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.gh = {
    enable = true;
    extensions = [
      pkgs.gh-copilot
    ];
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };

  programs.gh-dash = {
    enable = true;
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight";
      editor.file-picker.hidden = false;
    };
  };

  programs.htop = {
    enable = true;
  };

  programs.java = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };

  programs.lazygit = {
    enable = true;
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      command_timeout = 3000;
      character = {
        success_symbol = " [λ](bold green)";
        error_symbol = " [λ](bold red)";
      };
    };
  };

  # Neovim Configuration
  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "softinio";
    repo = "nvim-config";
    rev = "618913553a236132e558d9df85200ed0f357dc19";
    sha256 = "sha256-aYYR0KvX0vKg13Xn6l+2irJBjrIrlS5aBgkoZ5nn9yE=";
  };
}
