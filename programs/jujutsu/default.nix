{ ... }:
let
  MyAliases = {
    l = [
      "log"
      "-r"
      "(main..@):: | (main..@)-"
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
        diff.format = "git";
        diff.tool = [
          "difft"
          "--color=always"
          "$left"
          "$right"
        ];
        editor = "nvim";
        merge-editor = [
          "meld"
          "$left"
          "$base"
          "$right"
          "-o"
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
