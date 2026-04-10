{ ... }:

{
  programs.nixvim = {
    # Diagnostics display
    diagnostic.settings.virtual_text = true;

    plugins = {
      # Sane defaults for all servers
      lspconfig.enable = true;
    };
  };
}