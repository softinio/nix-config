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
      # Disk reclamation
      # The Saturday agent sequence on demand; nixgc because -g runs unprivileged.
      diskreclaim = "wtclean; and cache-sweep --yes; and nixgc; and nix-store --optimise";
      rmxcodederived = "rm -fr ~/Library/Developer/Xcode/DerivedData";
      # -d narrows the default cache list, which also matches tracked dist/build.
      wtclean = "worktree-audit -k -m -y -d node_modules,target,.venv,.direnv ~/Projects ~/OpenSource ~/Learn";

      # Git and review
      g = "git";
      gforksync = "git fetch upstream && git merge upstream/master && git push origin master";
      ghauth = "gh auth login --with-token < ~/.ghauth";
      gitpurgemain = ''git branch --merged | grep -v "\*" | grep -v "main" | xargs -n 1 git branch -d'';
      gitpurgemaster = ''git branch --merged | grep -v "\*" | grep -v "master" | xargs -n 1 git branch -d'';
      lg = "lazygit";
      linesofcode = "git ls-files | xargs wc -l";
      reviewr = "herdr plugin action invoke open --plugin persiyanov.reviewr";

      # Nix
      nixc = "cd ~/.config/nixpkgs";
      # sudo prunes the system generations, the second pass the home-manager ones.
      nixgc = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      nixinfo = "nix-shell -p nix-info --run \"nix-info -m\"";
      nixq = "nix-env -qa";
      nixre = "sudo -v && sudo darwin-rebuild switch --flake ~/.config/nixpkgs#${hostname}";
      nixstorerepair = "nix-store --repair --verify --check-contents";
      nixupgrade = "nix upgrade-nix";

      # Scala / JVM
      psbt = "pkill -f sbt";

      # Shell and file tools
      ".." = "cd ..";
      bf = "broot";
      cat = "bat";
      du = "dua i";
      fzfp = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'";
      grep = "grep --color=auto";
      l = "ll";
      ping = "prettyping";
      pj = "python -m json.tool";
      v = "nvim";

      # SSH and remote hosts
      addsshmac = "ssh-add  ~/.ssh/id_ed25519 --apple-use-keychain --apple-load-keychain";
      sshhcloud1 = "ssh salar@hcloud1.softinio.net";
      sshhcloud1r = "ssh root@hcloud1.softinio.net";
    };
  };
}
