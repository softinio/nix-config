{ pkgs, hostname, ... }:

{
  home.packages = with pkgs; [
    fishPlugins.foreign-env
    fishPlugins.bobthefish
  ];

  home.shell.enableFishIntegration = true;

  # programs.man.package is null on Darwin (stateVersion >= 26.05), so the
  # fish module's default of generateCaches = true has no effect and just warns.
  programs.man.generateCaches = false;

  programs.fish = {
    enable = true;

    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
      ot = ''
        set otresult (ollama run qwen2.5-coder "Provide only the MacOS terminal command (without markdown) to: $argv")
        commandline $otresult
      '';
    };

    plugins = [
      {
        name = "fish-ssh-agent";
        src = pkgs.fetchFromGitHub {
          owner = "danhper";
          repo = "fish-ssh-agent";
          rev = "f10d95775352931796fd17f54e6bf2f910163d1b";
          sha256 = "sha256-cFroQ7PSBZ5BhXzZEKTKHnEAuEu8W9rFrGZAb8vTgIE=";
        };
      }
    ];

    shellInitLast = ''
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

      set -xg PATH $HOME/bin $HOME/.local/bin $HOME/.cargo/bin $HOME/.npm-global/bin $HOME/.luarocks/bin $HOME/.nix-profile/bin /nix/var/nix/profiles/default/bin /usr/local/bin /usr/bin /bin /usr/sbin /sbin "/Applications/IntelliJ IDEA.app/Contents/MacOS" /Applications/WezTerm.app/Contents/MacOS $PATH

      set -xg WORKSPACE $HOME/Projects

      set -xg FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n

      set -xg DEVELOPER_DIR /Applications/Xcode.app/Contents/Developer
      set -xg TOOLCHAINS swift

      set -xg USE_BUILTIN_RIPGREP 0

      set -xg OPENAI_API_KEY (cat ~/.openai)
      set -xg ANTHROPIC_API_KEY (cat ~/.anthropic)
    '';

    interactiveShellInit = ''
      # Load keychain-stored SSH keys into the agent (needed for SSH commit
      # signing), but only when the agent has no identities yet.
      if not ssh-add -l >/dev/null 2>&1
        ssh-add --apple-load-keychain 2>/dev/null
      end

      jj util completion fish | source
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source
    '';

    shellAliases = {
      addsshmac = "ssh-add  ~/.ssh/id_ed25519 --apple-use-keychain --apple-load-keychain";
      bf = "broot";
      cat = "bat";
      du = "dua i";
      linesofcode = "git ls-files | xargs wc -l";
      fzfp = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'";
      ping = "prettyping";
      ".." = "cd ..";
      pj = "python -m json.tool";
      l = "ll";
      g = "git";
      ghauth = "gh auth login --with-token < ~/.ghauth";
      gitpurgemain = ''git branch --merged | grep -v "\*" | grep -v "main" | xargs -n 1 git branch -d'';
      gitpurgemaster = ''git branch --merged | grep -v "\*" | grep -v "master" | xargs -n 1 git branch -d'';
      gforksync = "git fetch upstream && git merge upstream/master && git push origin master";
      grep = "grep --color=auto";
      lg = "lazygit";
      nixc = "cd ~/.config/nixpkgs";
      nixre = "sudo -v && sudo darwin-rebuild switch --flake ~/.config/nixpkgs#${hostname}";
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
