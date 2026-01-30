{ user, ... }:

let
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
    "*.bloop"
    ".direnv/"
    ".idea/"
    ".mcp.json"
    ".mypy_cache"
    "*.metals"
    "*.metals.sbt"
    "*metals.sbt"
    "*.envrc"
    "*hie.yaml"
    "*.vscode"
    "_darcs/"
    "result"
    # Node.js / JavaScript
    "node_modules/"
    "npm-debug.log*"
    "yarn-debug.log*"
    "yarn-error.log*"
    ".pnpm-debug.log*"
    "dist/"
    "build/"
    "coverage/"
    ".env.local"
    ".env.*.local"
  ];
  gitConfig = {
    alias = myAliases;
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
        cmd = "'/Applications/IntelliJ IDEA.app/Contents/macOS/idea' merge \"$LOCAL\" \"$REMOTE\" \"$BASE\" \"$MERGED\"";
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
    # Commented out as xcode had issues with it.
    # url = {
    #   "git@github.com:" = {
    #     insteadOf = "https://github.com/";
    #   };
    # };
    user = {
      email = user.email;
      name = user.fullName;
    };
  };
in
{
  programs.git = {
    enable = true;
    settings = gitConfig;
    lfs.enable = true;
    ignores = myIgnores;
  };
}
