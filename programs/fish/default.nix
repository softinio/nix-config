{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fish
    fishPlugins.foreign-env
    fishPlugins.bobthefish
  ];

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
      jj util completion fish | source
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source
    '';

    shellAliases = {
      addsshmac = "ssh-add  ~/.ssh/id_ed25519 --apple-use-keychain --apple-load-keychain";
      bf = "broot";
      cat = "bat";
      du = "dua i";
      fzfp = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'";
      ping = "prettyping";
      ".." = "cd ..";
      pj = "python -m json.tool";
      l = "ll";
      g = "git";
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
      sshhcloud1 = "ssh salar@hcloud1.softinio.net";
      sshhcloud1r = "ssh root@hcloud1.softinio.net";
    };
  };
}
