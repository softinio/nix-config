{ ... }:

{
  programs.nixvim.plugins = {
    # Lazy loading support
    lz-n.enable = true;

    # File manager
    oil = {
      enable = true;
      lazyLoad.settings.cmd = "Oil";
    };

    # TODO comment highlighting
    todo-comments = {
      enable = true;
      keymaps.todoTelescope.key = "<leader>t";
    };

    # Diagnostics list
    trouble.enable = true;

    # Typst language preview
    typst-preview.enable = true;

    # Key binding help
    which-key.enable = true;
  };
}