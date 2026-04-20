{ ... }:

{
  programs.nixvim.plugins = {
    # Rest Client
    kulala.enable = true;

    # TODO comment highlighting
    todo-comments.enable = true;

    # Diagnostics list
    trouble.enable = true;

    # Typst language preview
    typst-preview.enable = true;

    # Key binding help
    which-key.enable = true;
  };
}
