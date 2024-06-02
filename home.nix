{
  config,
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
      "slack"
      "vscode"
      "vscode-extension-MS-python-vscode-pylance"
      "zoom"
    ];

  home = {
    stateVersion = "24.05";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "$EDITOR";
    };
    packages = with pkgs; [
      jdk21
      any-nix-shell
      aspell
      cachix
      cmake
      coursier
      curlFull
      delta
      deno
      devenv
      discord
      fd
      ffmpeg
      fishPlugins.foreign-env
      fishPlugins.bobthefish
      font-awesome
      gitAndTools.diff-so-fancy
      gnupg
      go
      graphviz
      luajit
      luajitPackages.luarocks
      luajitPackages.luasocket
      marksman
      maven
      metals
      multimarkdown
      mypy
      ncdu
      neofetch
      neovim
      niv
      nix-index
      nixfmt-rfc-style
      nix-prefetch-git
      nodejs
      nodePackages.pyright
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      ollama
      openssl
      oterm
      pandoc
      patchelf
      pngpaste
      prettyping
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
      skimpdf
      slack
      slides
      slumber
      sqlite
      stylua
      tealdeer
      tectonic
      texlab
      tig
      tokei
      tree
      tree-sitter
      wget
      xcodes
      xz
      yq
      zoom-us
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
    icons = true;
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
    };
  };

  programs.htop = {
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
    settings = {
      command_timeout = 1000;
      character = {
        success_symbol = " [λ](bold green)";
        error_symbol = " [λ](bold red)";
      };
    };
  };

  programs.vscode = {
    enable = true;
    extensions = [
      pkgs.vscode-extensions.scalameta.metals
      pkgs.vscode-extensions.usernamehw.errorlens
      pkgs.vscode-extensions.redhat.java
      pkgs.vscode-extensions.redhat.vscode-yaml
      pkgs.vscode-extensions.xyz.local-history
      pkgs.vscode-extensions.yzhang.markdown-all-in-one
      pkgs.vscode-extensions.svsool.markdown-memo
      pkgs.vscode-extensions.github.vscode-pull-request-github
      pkgs.vscode-extensions.github.vscode-github-actions
      pkgs.vscode-extensions.vscode-icons-team.vscode-icons
      pkgs.vscode-extensions.github.github-vscode-theme
      pkgs.vscode-extensions.jnoortheen.nix-ide
      pkgs.vscode-extensions.timonwong.shellcheck
      pkgs.vscode-extensions.skyapps.fish-vscode
      pkgs.vscode-extensions.baccata.scaladex-search
      pkgs.vscode-extensions.davidanson.vscode-markdownlint
      pkgs.vscode-extensions.ms-python.vscode-pylance
      pkgs.vscode-extensions.ms-python.python
      pkgs.vscode-extensions.mechatroner.rainbow-csv
      pkgs.vscode-extensions.mkhl.direnv
      pkgs.vscode-extensions.asvetliakov.vscode-neovim
      pkgs.vscode-extensions.rust-lang.rust-analyzer
    ];
    userSettings = {
      editor.fontFamily = "SF Mono";
      editor.fontSize = 16;
      editor.copyWithSyntaxHighlighting = true;
      telemetry.enableTelemetry = false;
      workbench.colorTheme = "Solarized Light";
      workbench.iconTheme = "vscode-icons";
      workbench.sideBar.location = "right";
      "githubPullRequests.pullBranch" = "never";
      "markdown.extension.preview.autoShowPreviewToSide" = true;
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
    };
  };

  programs.fish = {
    enable = true;

    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    plugins = [ ];

    loginShellInit = ''
      set -xg TERM xterm-256color
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      end

      if test -e $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        fenv source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      end

      set -xg PATH $HOME/bin $HOME/.cargo/bin $PATH

      set -xg PATH /Users/salar/.luarocks/bin:/Users/salar/bin:/Users/salar/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin $PATH

      set -xg WORKSPACE /Users/salar/Projects

      set -xg FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n

      set -xg TOOLCHAINS swift
    '';

    interactiveShellInit = ''
      set -xg PATH $HOME/bin $HOME/.cargo/bin $PATH
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source
      ssh-add  ~/.ssh/id_ed25519 --apple-use-keychain --apple-load-keychain
    '';

    shellAliases = {
      addsshmac = "ssh-add  ~/.ssh/id_ed25519 --apple-use-keychain --apple-load-keychain";
      cat = "bat";
      du = "ncdu --color dark -rr -x";
      fzfp = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'";
      ping = "prettyping";
      ".." = "cd ..";
      pj = "python -m json.tool";
      l = "ll";
      g = "git";
      gl = "git log";
      gc = "git commit -m";
      gca = "git commit -am";
      gws = "git status";
      gu = "gitui";
      ghauth = "gh auth login --with-token < ~/.ghauth";
      gitpurgemain = ''git branch --merged | grep -v "\*" | grep -v "main" | xargs -n 1 git branch -d'';
      gitpurgemaster = ''git branch --merged | grep -v "\*" | grep -v "master" | xargs -n 1 git branch -d'';
      giscala = "gitignore scala,vim,java,sbt > .gitignore";
      gforksync = "git fetch upstream && git merge upstream/master && git push origin master";
      grep = "grep --color=auto";
      lg = "lazygit";
      new-sbt = "sbt new scala/scala-seed.g8";
      nixc = "cd ~/.config/nixpkgs";
      nixre = "nix build && sudo ./result/activate";
      nixinfo = "nix-shell -p nix-info --run \"nix-info -m\"";
      nixgc = "nix-collect-garbage -d";
      nixq = "nix-env -qa";
      nixstorerepair = "nix-store --repair --verify --check-contents";
      nixupgrade = "nix upgrade-nix";
      rmxcodederived = "rm -fr ~/Library/Developer/Xcode/DerivedData";
      v = "nvim";
      wezk = "wezterm show-keys --lua";
      sshhcloud1 = "ssh salar@hcloud1.softinio.net";
      sshhcloud1r = "ssh root@hcloud1.softinio.net";
    };
  };

  # Neovim Configuration
  xdg.configFile."nvim".source = builtins.fetchGit {
    url = "https://code.softinio.com/softinio/nvim-config";
    rev = "71648bb0f862e67287ad34d4681740cec03901b2";
  };
}
