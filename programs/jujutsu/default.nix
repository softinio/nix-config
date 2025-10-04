{ ... }:
let
  MyAliases = {
    l = [
      "log"
      "-r"
      "(main@origin..@):: | (main@origin..@)-"
    ];
  };
in
{
  programs.jujutsu = {
    enable = true;
    settings = {
      aliases = MyAliases;
      signing = {
        key = "~/.ssh/id_ed25519.pub";
      };
      ui = {
        default-command = "log";
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
