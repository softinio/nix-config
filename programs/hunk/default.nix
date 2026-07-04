{ ... }:

{
  programs.hunk = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      theme = "graphite";
      mode = "split";
      line_numbers = true;
    };
  };
}
