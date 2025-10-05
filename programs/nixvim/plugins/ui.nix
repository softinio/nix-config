{ ... }:

{
  programs.nixvim = {
    # Colorscheme
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "night";
        on_colors.__raw = "function(colors) colors.bg = \"#000000\" end";
      };
    };

    plugins = {
      # Icons for file types
      web-devicons.enable = true;

      # Color highlighter (shows colors in code)
      colorizer = {
        enable = true;
        settings.user_default_options.names = false;
      };

      # Indentation guides
      indent-blankline.enable = true;

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