{ ... }:

let
  gitConfig = {
    core = {
      editor = "nvim";
      pager = "delta";
    };
    delta = {
      "line-numbers" = true;
      "hyperlinks" = true;
      "side-by-side" = true;
    };
    diff = {
      colorMoved = "default";
      tool = "nvim";
    };
    difftool.nvim = {
      cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
      prompt = false;
    };
    fetch.prune = true;
    init.defaultBranch = "main";
    interactive = {
      diffFilter = "delta --color-only";
    };
    merge.conflictstyle = "diff3";
    merge.tool = "nvim";
    mergetool.nvim = {
      cmd = "nvim -d -c \"wincmd l\" -c \"norm ]c\" \"$LOCAL\" \"$MERGED\" \"$REMOTE\"";
      prompt = false;
      keepBackup = false;
    };
    # url = {
    #   "git@github.com:" = {
    #     insteadOf = "https://github.com/";
    #   };
    # };
    pull = {
      rebase = true;
    };
  };
  myAliases = {
    ci = "commit";
    cim = "commit -m";
    cia = "commit -am";
    co = "checkout";
    cob = "checkout -b";
    di = "diff";
    gpo = "push origin";
    main = "checkout main";
    master = "checkout master";
    st = "status";
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
