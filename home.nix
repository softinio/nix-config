{ config, lib, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = (import ./programs);

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
  ];

  home = {
    stateVersion = "23.05";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "$EDITOR";
    };
    packages = with pkgs; [
      jdk21
      any-nix-shell
      aspell
      bloop
      cabal-install
      cabal2nix
      cachix
      cmake
      coursier
      curlFull
      delta
      fd
      ffmpeg
      fishPlugins.bass
      fishPlugins.foreign-env
      fishPlugins.bobthefish
      font-awesome
      gitAndTools.diff-so-fancy
      ghc
      ghcid
      gnupg
      go
      graphviz
      haskell-language-server
      hugo
      luajit
      luajitPackages.luarocks
      luajitPackages.luasocket
      marksman
      maven
      multimarkdown
      mypy
      ncdu
      neofetch
      neovim
      niv
      nix-index
      nixfmt
      nix-prefetch-git
      nodejs
      nodePackages.pyright
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      openssl
      pandoc
      patchelf
      prettyping
      rclone
      readline
      ripgrep
      # ripgrep-all
      rnix-lsp
      rustup
      sbt
      scala-cli
      shellcheck
      slides
      sqlite
      stylua
      stack
      tealdeer
      tectonic
      texlab
      tig
      tokei
      tree
      tree-sitter
      # wget
      xz
      yq
    ];
  };

  programs.bat = {
      enable = true;
  };

  programs.btop = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
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
    };
  };

  programs.gh-dash = {
    enable = true;
  };

  programs.gitui = {
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

  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    font = { 
      name = "FiraCode Nerd Font Mono Retina";
      size = 16;
    };
    settings = {
      copy_on_select = true;
      enabled_layouts = "*";
      macos_quit_when_last_window_closed = true;
      scrollback_lines = 50000;
      kitty_mod = "ctrl+cmd";
    };
  };

  # programs.nheko = {
  #   enable = true;
  #   settings = {
  #     scaleFactor = 1.0;
  #     user = {
  #       alertOnNotification = true;
  #     };
  #   };
  # };

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
      pkgs.vscode-extensions.xyz.local-history
      pkgs.vscode-extensions.yzhang.markdown-all-in-one
      pkgs.vscode-extensions.svsool.markdown-memo
      pkgs.vscode-extensions.github.vscode-pull-request-github
      pkgs.vscode-extensions.github.github-vscode-theme
      pkgs.vscode-extensions.jnoortheen.nix-ide
      pkgs.vscode-extensions.timonwong.shellcheck
      pkgs.vscode-extensions.skyapps.fish-vscode
      pkgs.vscode-extensions.baccata.scaladex-search
      pkgs.vscode-extensions.davidanson.vscode-markdownlint
    ];
    userSettings = {
      editor.fontFamily = "FiraCode Nerd Font Mono Retina";
      editor.fontSize = 16;
      telemetry.enableTelemetry = false;
      workbench.colorTheme = "Solarized Light";
      workbench.iconTheme = "vscode-icons";
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

      set -xg PATH /Users/salar/.luarocks/bin:/nix/store/95wpywsjf5iiw77f6n9rw347lk1sly15-luarocks-3.2.1/bin:/Users/salar/bin:/Users/salar/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/nix/store/3qp71mhrpxxg080yc82k51nx7b5hkajr-kitty-0.21.2/Applications/kitty.app/Contents/MacOS $PATH

      set -xg PATH "/Users/salar/Library/Application Support/Coursier/bin" $PATH

      set -xg JAVA_HOME /Users/salar/.nix-profile

      set -xg JDTLS_CONFIG /Users/salar/.config/jdt-language-server/config_mac

      set -xg JAR /Users/salar/.config/jdt-language-server/plugins/org.eclipse.equinox.launcher_1.6.200.v20210416-2027.jar

      set -xg WORKSPACE /Users/salar/Projects

      set -xg NIX_PATH $HOME/.nix-defexpr/channels $NIX_PATH

      set -xg FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n

      set -xg TOOLCHAINS swift

      set -xg XDG_CONFIG_HOME $HOME/.config

      set -xg LUA_PATH "/nix/store/95wpywsjf5iiw77f6n9rw347lk1sly15-luarocks-3.2.1/share/lua/5.1/?.lua;/nix/store/95wpywsjf5iiw77f6n9rw347lk1sly15-luarocks-3.2.1/share/lua/5.1/?/init.lua;/Users/salar/.luarocks/share/lua/5.1/?.lua;/Users/salar/.luarocks/share/lua/5.1/?/init.lua"

      set -xg LUA_CPATH "?.so;/nix/store/95wpywsjf5iiw77f6n9rw347lk1sly15-luarocks-3.2.1/share/lua/5.1/?/init.lua;/Users/salar/.luarocks/lib/lua/5.1/?.so;/nix/store/95wpywsjf5iiw77f6n9rw347lk1sly15-luarocks-3.2.1/lib/lua/5.1/?.so"
      '';

    interactiveShellInit = ''
      set -xg PATH $HOME/bin $HOME/.cargo/bin $PATH
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source
      ssh-add  ~/.ssh/id_ed25519 --apple-use-keychain --apple-load-keychain
    '';

    shellAliases = {
      addsshmac="ssh-add  ~/.ssh/id_ed25519 --apple-use-keychain --apple-load-keychain";
      cat="bat";
      du="ncdu --color dark -rr -x";
      fzfp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'";
      ping="prettyping";
      ".." = "cd ..";
      pj="python -m json.tool";
      l="ll";
      g="git";
      gl="git log";
      gc="git commit -m";
      gca="git commit -am";
      gws="git status";
      gu="gitui";
      ghauth="gh auth login --with-token < ~/.ghauth";
      gitpurgemain=''git branch --merged | grep -v "\*" | grep -v "main" | xargs -n 1 git branch -d'';
      gitpurgemaster=''git branch --merged | grep -v "\*" | grep -v "master" | xargs -n 1 git branch -d'';
      giscala="gitignore scala,vim,java,sbt > .gitignore";
      gforksync="git fetch upstream && git merge upstream/master && git push origin master";
      grep="grep --color=auto";
      new-sbt="sbt new scala/scala-seed.g8";
      nixc="cd ~/.config/nixpkgs";
      nixre="nix build && sudo ./result/activate";
      nixinfo="nix-shell -p nix-info --run \"nix-info -m\"";
      nixgc="nix-collect-garbage -d";
      nixq="nix-env -qa";
      nixupgrade="nix upgrade-nix";
      obsidian="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Notes";
      rmxcodederived="rm -fr ~/Library/Developer/Xcode/DerivedData";
      v="nvim";
      wezk="wezterm show-keys --lua";
      sshfre1="ssh salar@fre1.softinio.net";
      sshfre2="ssh -p 2022 salar@fre2.softinio.net";
      sshhcloud1="ssh salar@hcloud1.softinio.net";
      sshhcloud1r="ssh root@hcloud1.softinio.net";
    };
  };

  # Neovim Configuration
  xdg.configFile."nvim".source = builtins.fetchGit {
    url = "https://git.softinio.com/nvim-config.git";
    rev = "a2a4948626b84eb5115d2826afc76978c659e535";
  };
}

