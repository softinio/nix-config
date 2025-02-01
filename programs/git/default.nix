{ ... }:

let
  gitConfig = {
    core = {
      editor = "nvim";
    };
    diff = {
      colorMoved = "default";
      external = "difft";
      tool = "difftastic";
    };
    difftool.difftastic = {
      cmd = "difft \"$MERGED\" \"$LOCAL\" \"abcdef1\" \"100644\" \"$REMOTE\" \"abcdef2\" \"100644\"";
      prompt = false;
    };
    difftool.nvim = {
      cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
      prompt = false;
    };
    fetch.prune = true;
    init.defaultBranch = "main";
    merge.tool = "intellij";
    mergetool = {
      intellij = {
        cmd = "'/Applications/IntelliJ IDEA.app/Contents/macOS/idea' merge \“$LOCAL\” \“$REMOTE\” \“$BASE\” \“$MERGED\”";
        trustExitCode = true;
      };
      keepBackup = false;
    };
    pager = {
      difftool = true;
    };
    pull = {
      rebase = true;
    };
    url = {
      "git@github.com:" = {
        insteadOf = "https://github.com/";
      };
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
    ".DS_Store"
    ".aider*"
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
