{ ... }:

{
  programs.nixvim.plugins = {
    # Auto-close brackets and quotes
    nvim-autopairs.enable = true;

    # Flash jump/search enhancement
    flash.enable = true;

    # Image clipboard support
    img-clip = {
      enable = true;
      settings = {
        default = {
          embed_image_as_base64 = false;
          prompt_for_file_name = false;
          drag_and_drop = {
            insert_mode = true;
          };
          use_absolute_path = true;
        };
      };
    };

    # Trim trailing whitespace
    trim = {
      enable = true;
      settings = {
        highlight = true;
        ft_blocklist = [
          "checkhealth"
          "floaterm"
          "lspinfo"
          "neo-tree"
          "TelescopePrompt"
        ];
      };
    };

    # Collection of small useful plugins
    snacks.enable = true;

    # Zig language
    zig.enable = true;
  };
}
