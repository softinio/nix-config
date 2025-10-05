{ ... }:

{
  programs.nixvim = {
    # Diagnostics display
    diagnostic.settings.virtual_text = true;

    plugins = {
      # Auto-format on save
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };

      # Sane defaults for all servers
      lspconfig.enable = true;
    };
  };
}