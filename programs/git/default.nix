{ config, pkgs, ... }:

let
  gitConfig = {
    core = {
      editor = "nvim";
      pager  = "diff-so-fancy | less --tabs=4 -RFX";
    };
    init.defaultBranch = "main";
    merge.conflictStyle = "diff3";
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
    fetch.prune = true;
    pull = {
      rebase = true;
    };
  };
  myAliases = {
    ci = "commit";
    co = "checkout";
    main = "checkout main";
    master = "checkout master";
  };
  myIgnores = [
      "*~"
      ".DS_Store"
      "*.bloop"
      ".direnv/"
      ".idea/"
      ".mypy_cache"
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
      "result"
    ];
in
{
  programs.git = {
    enable = true;
    userEmail = "code@softinio.com";
    userName = "Salar Rahmanian";
    aliases = myAliases;
    ignores = myIgnores;
    extraConfig = gitConfig;
  };
}
