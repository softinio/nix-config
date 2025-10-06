{ ... }:
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
        key = "~/.ssh/id_ed25519.pub";
      };
      templates = {
        git_push_bookmark = "\"softinio/push-\" ++ change_id.short()";
      };
      ui = {
        default-command = "l";
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
        name = "Salar Rahmanian";
        email = "code@softinio.com";
      };
    };
  };
}
