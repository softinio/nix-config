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

    # Collection of small useful plugins
    snacks = {
      enable = true;
      settings = {
        bigfile = {
          enabled = true;
        };
        image = {
          enabled = true;
        };
        notifier = {
          enabled = true;
          timeout = 5000;
        };
        quickfile = {
          enabled = true;
        };
        statuscolumn = {
          enabled = true;
        };
      };
    };

    # Zig language
    zig.enable = true;
  };
}
