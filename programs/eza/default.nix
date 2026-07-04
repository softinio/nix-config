{ ... }:

{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--long"
      "--header"
      "--all"
    ];
  };
}
