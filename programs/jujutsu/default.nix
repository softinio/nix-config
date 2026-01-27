{ pkgs, user, ... }:
let
  MyAliases = {
    l = [
      "log"
      "-r"
      "ancestors(reachable(@, mutable()), 2)"
    ];
    n = [ "new" ];
    tug = [
      "bookmark"
      "move"
      "--from"
      "closest_bookmark(@-)"
      "--to"
      "@-"
    ];
  };
in
{
  programs.jujutsu = {
    enable = true;
    settings = {
      aliases = MyAliases;
      gerrit.enabled = false;
      git = {
        subprocess = true;
      };
      signing = {
        key = user.gitSigningKey;
      };
      templates = {
        git_push_bookmark = "\"${user.jujutsuBranchPrefix}-push-\" ++ change_id.short()";
      };
      ui = {
        default-command = "st";
        diff-formatter = [
          "difft"
          "--color=always"
          "$left"
          "$right"
        ];
        editor = "nvim";
        merge-editor = [
          "idea"
          "$left"
          "$right"
          "$base"
          "$output"
        ];
        pager = "less -FRX";
      };
      user = {
        name = user.fullName;
        email = user.email;
      };
    };
  };
}
