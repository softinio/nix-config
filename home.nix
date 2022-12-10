{ config, lib, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = (import ./programs);

  nixpkgs.overlays = [
    (import ./overlays/sumneko-lua-language-server)
    # (import (builtins.fetchTarball {
    #   url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    # }))
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
  ];

  home = {
    stateVersion = "22.11";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "$EDITOR";
    };
    packages = with pkgs; [
      ( python310.withPackages (ps: with ps; [ pip flake8 black ]) )
#      adoptopenjdk-hotspot-bin-17
      jdk
      any-nix-shell
      aspell
      bloop
      cabal-install
      cabal2nix
      cachix
      cmake
      coursier
      curlFull
      exa
      fd
      ffmpeg
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
      lorri
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
      nodePackages.pyright
      nodePackages.typescript-language-server
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      openssl
      pandoc
      patchelf
      pijul
      rclone
      readline
      ripgrep
      ripgrep-all
      rnix-lsp
      rust-analyzer
      rustup
      sbt
      scala-cli
      shellcheck
      sqlite
      stylua
      stack
      sumneko-lua-language-server
      tealdeer
      tectonic
      texlab
      tig
      tokei
      tree
      tree-sitter
      wget
      xz
      yq
    ];
  };

  programs.bat = {
      enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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

  programs.htop = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    font = { 
      name = "FiraCode Nerd Font Mono Retina";
      size = 16;
    };
    settings = {
      copy_on_select = true;
      enabled_layouts = "*";
      macos_quit_when_last_window_closed = true;
      scrollback_lines = 10000;
    };
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

    plugins = [
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "50eba266b0d8a952c7230fca1114cbc9fbbdfbd4";
          sha256 = "0ppmajynpb9l58xbrcnbp41b66g7p0c9l2nlsvyjwk6d16g4p4gy";
        };
      }
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
      {
        name = "bobthefish";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-bobthefish";
          rev = "a2ad38aa051aaed25ae3bd6129986e7f27d42d7b";
          sha256 = "1fssb5bqd2d7856gsylf93d28n3rw4rlqkhbg120j5ng27c7v7lq";
        };
      }
    ];

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
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source
    '';

    shellAliases = {
      cat="bat";
      du="ncdu --color dark -rr -x";
      fzfp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'";
      ping="prettyping";
      ".." = "cd ..";
      pj="python -m json.tool";
      l="exa --long --header --git --all";
      g="git";
      gl="git log";
      gc="git commit -m";
      gca="git commit -am";
      gws="git status";
      ghauth="gh auth login --with-token < ~/.ghauth";
      giscala="gitignore scala,vim,java,sbt > .gitignore";
      gforksync="git fetch upstream && git merge upstream/master && git push origin master";
      grep="grep --color=auto";
      new-sbt="sbt new scala/scala-seed.g8";
      nixre="nix build && sudo ./result/activate";
      nixinfo="nix-shell -p nix-info --run \"nix-info -m\"";
      nixgc="nix-collect-garbage -d";
      nixq="nix-env -qa";
      nixupdate="sudo nix-channel --update";
      nixversion="nix eval nixpkgs.lib.version";
      rmxcodederived="rm -fr ~/Library/Developer/Xcode/DerivedData";
      v="nvim";
      sshfre1="ssh salar@fre1.softinio.net";
      sshfre2="ssh -p 22 salar@fre2.softinio.net";
    };
  };

  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text = lib.mkAfter ''
    for f in $plugin_dir/*.fish
      source $f
    end
    '';

  # Neovim Configuration
  xdg.configFile."nvim/lua/salargalaxyline.lua".source = programs/neovim/settings/salargalaxyline.lua;
  xdg.configFile."nvim/init.lua".source = programs/neovim/init.lua;
}
