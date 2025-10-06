{ ... }:

{
  programs.nixvim.plugins = {
    # Git signs in the gutter
    gitsigns = {
      enable = true;
      settings.signs = {
        add.text = "+";
        change.text = "~";
        delete.text = "_";
        topdelete.text = "‾";
        changedelete.text = "~";
      };
    };
  };
}