{ ... }:

{
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--glob=!.git/*"
      "--glob=!.jj/*"
      "--glob=!node_modules/"
    ];
  };

  programs.ripgrep-all = {
    enable = true;
  };
}
