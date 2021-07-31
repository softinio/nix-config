{ config, lib, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = (import ./programs);

  nixpkgs.overlays = [
    (import ./overlays/sumneko-lua-language-server)
  ];

  home = {
    username = "salar";
    homeDirectory = "/Users/salar";
    stateVersion = "21.11";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "$EDITOR";
    };
  };

  programs.bat = {
      enable = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.gh = {
    enable = true;
    editor = "nvim";
    gitProtocol = "ssh";
  };

  programs.htop = {
    enable = true;
  };

  programs.jq = {
    enable = true;
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

  programs.fish = {
    enable = true;

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

      set -xg PATH $HOME/bin $PATH

      set -xg JAVA_HOME /Users/salar/.nix-profile/bin

      set -xg JDTLS_CONFIG /Users/salar/.config/jdt-language-server/config_mac

      set -xg JAR /Users/salar/.config/jdt-language-server/plugins/org.eclipse.equinox.launcher_1.6.200.v20210416-2027.jar

      set -xg WORKSPACE /Users/salar/Projects

      set -xg NIX_PATH $HOME/.nix-defexpr/channels $NIX_PATH

      set -xg FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n

      set -xg TOOLCHAINS swift

      set -xg XDG_CONFIG_HOME $HOME/.config
      '';

    promptInit = ''
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
      gforksync="git fetch upstream && git merge upstream/master && git push origin master";
      grep="grep --color=auto";
      new-sbt="sbt new scala/scala-seed.g8";
      nixre="home-manager switch";
      nixedit="home-manager edit";
      nixinfo="nix-shell -p nix-info --run \"nix-info -m\"";
      nixgc="nix-collect-garbage -d";
      nixq="nix-env -qa";
      nixupdate="nix-channel --update";
      nixupgrade="nix upgrade-nix";
      nixup="nix-env -u";
      nixversion="nix eval nixpkgs.lib.version";
      nixdaemon="sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist && launchctl start org.nixos.nix-daemon";
      rmxcodederived="rm -fr ~/Library/Developer/Xcode/DerivedData";
      v="nvim";
      tabninecfg="vc /Users/salar/Library/Preferences/TabNine/TabNine.toml";
      sshfre1="ssh salar@fre1.softinio.net";
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

  home.packages = [
    pkgs.adoptopenjdk-bin
    pkgs.any-nix-shell
    pkgs.asciinema
    pkgs.aspell
    pkgs.awscli
    pkgs.bloop
    pkgs.cabal-install
    pkgs.cmake
    pkgs.coursier
    pkgs.curlFull
    pkgs.direnv
    pkgs.dust
    pkgs.exa
    pkgs.fd
    pkgs.ffmpeg
    pkgs.ghcid
    pkgs.gitAndTools.diff-so-fancy
    pkgs.global
    pkgs.gnupg
    pkgs.gradle
    pkgs.graphviz
    pkgs.hlint
    pkgs.httpie
    pkgs.hugo
    pkgs.hyperfine
    pkgs.jansson
    pkgs.luajit
    pkgs.luajitPackages.luarocks
    pkgs.maven
    pkgs.multimarkdown
    pkgs.ncdu
    pkgs.neofetch
    pkgs.neovim
    pkgs.niv
    pkgs.nixFlakes
    pkgs.nixfmt
    pkgs.nodePackages.pyright
    pkgs.openssl
    pkgs.pandoc
    pkgs.pgcli
    pkgs.prettyping
    pkgs.procs
    pkgs.procs
    pkgs.ranger
    pkgs.readline
    pkgs.ripgrep
    pkgs.rnix-lsp
    pkgs.sbt
    pkgs.shellcheck
    pkgs.stylua
    pkgs.sumneko-lua-language-server
    pkgs.tealdeer
    pkgs.tig
    pkgs.tokei
    pkgs.tree
    pkgs.universal-ctags
    pkgs.vscodium
    pkgs.wget
    pkgs.xz
    pkgs.yq
  ];
}
