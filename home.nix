{
  inputs,
  lib,
  pkgs,
  user,
  ...
}:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    inputs.nixvim.homeModules.nixvim
    ./nix-apps-activation.nix
  ]
  ++ (import ./programs);

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "copilot.vim"
      "copilot-language-server"
      "discord"
      "github-copilot-cli"
      "ijhttp"
      "slack"
      "vscode"
      "vscode-extension-github-copilot"
      "vscode-extension-github-copilot-chat"
      "vscode-extension-MS-python-vscode-pylance"
      "vscode-extension-visualjj-visualjj"
    ];

  home = {
    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = with pkgs; [
      any-nix-shell
      aspell
      ast-grep
      awscli2
      awsebcli
      basedpyright
      bash-language-server
      bloop
      cachix
      colordiff
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
      gg-jj
      ghostscript
      github-copilot-cli
      gnupg
      go
      graphviz
      ijhttp
      imagemagick
      jetbrains-mono
      jjui
      jq-lsp
      lazyjj
      luajit
      lua-language-server
      marksman
      marp-cli
      maven
      mermaid-cli
      metals
      multimarkdown
      mypy
      nerd-fonts.fira-code
      nil
      niv
      nixd
      nix-index
      nixfmt
      nix-prefetch-git
      nodejs
      openssl
      pandoc
      patchelf
      pijul
      pngpaste
      prettier
      prettyping
      pyrefly
      python3
      python3Packages.huggingface-hub
      python3Packages.jupyterlab
      rclone
      readline
      rustup
      sbt
      scala-cli
      scalafmt
      shellcheck
      slack
      slides
      slumber
      sqlite
      stylua
      tealdeer
      tectonic-unwrapped
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
      zig
      zls
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
    author = [ "${user.fullName} <${user.email}>" ];
    boring = [
      "^.idea$"
      "^.direnv$"
      "^.envrc$"
      "^.vscode$"
      "^.gitignore$"
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

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--glob=!.git/*"
      "--glob=!.jj/*"
      "--glob=!node_modules/"
    ];
  };

  programs.ripgrep-all = {
    enable = true;
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

      # Custom darcs repository status
      custom.darcs = {
        description = "Display darcs repository status";
        command = "darcs whatsnew --summary 2>/dev/null | wc -l | tr -d ' '";
        when = "test -d _darcs";
        symbol = "⚖️  ";
        style = "bold purple";
        format = "[$symbol($output )]($style)";
      };
    };
  };

  # darcs defaults
  home.file.".darcs/defaults".text = ''
    diff diff-command colordiff -rN -u %1 %2
  '';

  # pijul config
  xdg.configFile."pijul/config.toml".text = lib.mkAfter ''
    [author]
    name = "${user.username}"
    full_name = "${user.fullName}"
    email = "${user.email}"
  '';
}
