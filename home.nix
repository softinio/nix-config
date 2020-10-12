{ config, lib, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "salar";
  home.homeDirectory = "/Users/salar";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.git = {
    enable = true;
    userEmail = "code@softinio.com";
    userName = "Salar Rahmanian";
    ignores = [
      "*~"
      ".DS_Store"
      "*.bloop"
      "*.metals"
      "*.metals.sbt"
      "*metals.sbt"
      "*.direnv"
      "*.envrc" # there is lorri, nix-direnv & simple direnv; let people decide
      "*hie.yaml" # ghcide files
      "*.mill-version" # used by metals
      "*.idea"
      "*.vscode"
      "*.python-version"
    ];
    extraConfig = {
      core = {
        editor = "emacs -nw";
      };
      merge.tool = "intellij";
      mergetool = {
        cmd = "idea merge \"$LOCAL\" \"$REMOTE\" \"$BASE\" \"$MERGED\"";
        trustExitCode = true;
        prompt = false;
      };
      diff.tool = "intellij";
      difftool = {
        cmd = "idea diff \"$LOCAL\" \"$REMOTE\"";
        prompt = false;
      };
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
      pull = {
        rebase = true;
      };
    };
  };

  programs.bat = {
      enable = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.kitty = {
    enable = true;
    font.name = "SF Mono";
    settings = {
      font_size = 20;
    };
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableNixDirenvIntegration = true;
  };

  programs.htop = {
    enable = true;
    sortDescending = true;
    sortKey = "PERCENT_CPU";
  };

  programs.jq = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      character.symbol = "λ";
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
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      end

      if test -e $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        fenv source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      end

      set PATH $HOME/.emacs.d/bin /opt/local/bin $HOME/bin $PATH

      set JAVA_HOME /Users/salar/.nix-profile/bin/java

      set -xg FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n
      '';

    promptInit = ''
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source
    '';

    shellAliases = {
      cat="bat";
      du="ncdu --color dark -rr -x";
      ping="prettyping";
      ".." = "cd ..";
      pj="python -m json.tool";
      k="exa --long --header --git --all";
      g="git";
      gl="git log";
      gc="git commit -m";
      gca="git commit -am";
      gws="git status";
      gforksync="git fetch upstream && git merge upstream/master && git push origin master";
      grep="grep --color=auto";
      new-sbt="sbt new scala/scala-seed.g8";
      nixre="home-manager switch";
      nixgc="nix-collect-garbage -d";
      nixq="nix-env -qa";
      nixupdate="nix-channel --update";
      nixupgrade="nix upgrade-nix";
      nixup="nix-env -u";
      nixversion="nix eval nixpkgs.lib.version";
      nixdaemon="sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist && launchctl start org.nixos.nix-daemon";
      v="emacs -nw";
      vc="emacsclient -c -a ''";
      em="emacsclient -t -a ''";
      tabninecfg="vc /Users/salar/Library/Preferences/TabNine/TabNine.toml";
      sshfre1="ssh salar@fre1.softinio.net";
      moshfre1="mosh salar@fre1.softinio.net";
      portsupdate="sudo port -v selfupdate";
    };
  };

  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text = lib.mkAfter ''
    for f in $plugin_dir/*.fish
      source $f
    end
    '';

  nixpkgs.overlays = [
    (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
  ];


  home.packages = [
    pkgs.awscli
    pkgs.pgcli
    pkgs.tig
    pkgs.ripgrep
    pkgs.go
    pkgs.hugo
    pkgs.jansson
    pkgs.universal-ctags
    pkgs.httpie
    pkgs.global
    pkgs.fd
    pkgs.curlFull
    pkgs.wget
    pkgs.readline
    pkgs.tree
    pkgs.exa
    pkgs.mosh
    pkgs.sbt
    pkgs.scala
    pkgs.scalafmt
    pkgs.coursier
    pkgs.ammonite
    pkgs.bloop
    pkgs.yarn
    pkgs.openssl
    pkgs.xz
    pkgs.gitAndTools.hub
    pkgs.gitAndTools.diff-so-fancy
    pkgs.nodejs-12_x
    pkgs.rustup
    pkgs.jdk11
    pkgs.mdbook
    pkgs.ranger
    pkgs.gnupg
    pkgs.exercism
    pkgs.niv
    pkgs.ffmpeg
    pkgs.gradle
    pkgs.maven
    pkgs.procs
    pkgs.emacsUnstable
    pkgs.shellcheck
    pkgs.cabal-install
    pkgs.hlint
    pkgs.ghcid
    pkgs.pandoc
    pkgs.multimarkdown
    pkgs.direnv
    pkgs.nixfmt
    pkgs.cmake
    pkgs.any-nix-shell
    pkgs.asciinema
    pkgs.ncdu
    pkgs.prettyping
    pkgs.rnix-lsp
  ];
}
