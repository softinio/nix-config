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
      "vscode-extension-github-copilot"
      "vscode-extension-github-copilot-chat"
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
      any-nix-shell
      aspell
      basedpyright
      bash-language-server
      cachix
      cmake
      coursier
      curlFull
      delta
      deno
      devenv
      discord
      dua
      fd
      ffmpeg
      fishPlugins.foreign-env
      fishPlugins.bobthefish
      font-awesome
      gitAndTools.diff-so-fancy
      gnupg
      go
      graphviz
      jq-lsp
      luajit
      lua-language-server
      marksman
      marp-cli
      maven
      metals
      multimarkdown
      mypy
      neofetch
      neovim
      nil
      niv
      nixd
      nix-index
      nixfmt-rfc-style
      nix-prefetch-git
      nodejs
      ollama
      openssl
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
      typescript
      typescript-language-server
      wget
      vscode-langservers-extracted
      # xcodes
      xz
      yaml-language-server
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
      command_timeout = 1000;
      character = {
        success_symbol = " [λ](bold green)";
        error_symbol = " [λ](bold red)";
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
      eval (ssh-agent -c)
      ssh-add  ~/.ssh/id_ed25519 --apple-use-keychain --apple-load-keychain
    '';

    shellAliases = {
      addsshmac = "ssh-add  ~/.ssh/id_ed25519 --apple-use-keychain --apple-load-keychain";
      cat = "bat";
      du = "dua i";
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
    rev = "902fbd939c74ece8fabe543e511af36471a1a197";
  };
}
