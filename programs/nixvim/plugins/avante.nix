{ ... }:

{
  programs.nixvim = {
    plugins.avante = {
      enable = true;
      settings = {
        provider = "claude";
        providers = {
          claude = {
            model = "claude-sonnet-4-6";
          };
        };
      };
    };
  };
}
