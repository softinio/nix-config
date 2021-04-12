{ config, pkgs, ... }:

let
  gitConfig = {
    core = {
      editor = "nvim";
      pager  = "diff-so-fancy | less --tabs=4 -RFX";
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
in
{
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
    extraConfig = gitConfig;
  };
}
