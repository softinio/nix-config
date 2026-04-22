{
  inputs,
  lib,
  pkgs,
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
      "github-copilot-cli"
      "ijhttp"
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
      awscli2
      awsebcli
      bash-language-server
      bloop
      cachix
      colordiff
      cmake
      coursier
      curlFull
      devenv
      difftastic
      dua
      fd
      ffmpeg
      font-awesome
      ghostscript
      github-copilot-cli
      gnupg
      go
      graphviz
      grpcurl
      httpyac
      ijhttp
      imagemagick
      jetbrains-mono
      jq-lsp
      luajit
      lua-language-server
      mermaid-cli
      metals
      multimarkdown
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
      pngpaste
      prettier
      prettyping
      pyrefly
      python3
      readline
      rustup
      shellcheck
      slumber
      sqlite
      stylua
      tealdeer
      tmux-sessionizer
      tokei
      tree
      tree-sitter
      typescript
      typescript-language-server
      wget
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      # uv: activate the project's own venv managed by uv
      layout_uv() {
        if [[ -d .venv ]]; then
          VIRTUAL_ENV="$(pwd)/.venv"
        else
          uv venv .venv
          VIRTUAL_ENV="$(pwd)/.venv"
        fi
        export VIRTUAL_ENV
        PATH_add "$VIRTUAL_ENV/bin"
        export UV_ACTIVE=1
      }

      # poetry: activate the poetry-managed venv for the project
      layout_poetry() {
        local venv
        venv=$(poetry env info --path 2>/dev/null)
        if [[ -z $venv ]]; then
          poetry install --no-root
          venv=$(poetry env info --path)
        fi
        export VIRTUAL_ENV="$venv"
        PATH_add "$venv/bin"
      }
    '';
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
    };
  };
}
