{ config, pkgs, ... }:

let
  gitConfig = {
    core = {
      editor = "nvim";
      pager = "diff-so-fancy | less --tabs=4 -RFX";
    };
    init.defaultBranch = "main";
    merge.conflictstyle = "diff3";
    merge.tool = "nvim";
    mergetool.nvim = {
      cmd = "nvim -d -c \"wincmd l\" -c \"norm ]c\" \"$LOCAL\" \"$MERGED\" \"$REMOTE\"";
      prompt = false;
      keepBackup = false;
    };
    diff.tool = "nvim";
    difftool.nvim = {
      cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
      prompt = false;
    };
    # url = {
    #   "git@github.com:" = {
    #     insteadOf = "https://github.com/";
    #   };
    # };
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
    "*.envrc" # there is lorri, nix-direnv & simple direnv; let people decide
    "*hie.yaml" # ghcide files
    "*.mill-version" # used by metals
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
