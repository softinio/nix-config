{ ... }:

{
  programs.nixvim = {
    # Colorscheme
    colorschemes.gruvbox = {
      enable = true;
      settings.contrast = "";
    };

    opts.background = "light";

    plugins = {
      # Icons for file types
      web-devicons.enable = true;

      # Color highlighter (shows colors in code)
      colorizer = {
        enable = true;
        settings.user_default_options.names = false;
      };

      # Markdown preview with live rendering
      markview.enable = true;

      # UI component library
      nui.enable = true;

      # Loading/progress indicators
      fidget.enable = true;

      # Status line (imported from separate file)
      # lualine is in lualine.nix
    };
  };
}