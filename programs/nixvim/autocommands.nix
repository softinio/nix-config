{ ... }:

{
  programs.nixvim.autoCmd = [
    # Vertically center document when entering insert mode
    {
      event = "InsertEnter";
      command = "norm zz";
    }

    # Open help in a vertical split
    {
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "markdown"
      ];
      command = "setlocal spell spelllang=en";
    }

    # Set indentation for specific filetypes
    {
      event = "FileType";
      pattern = ["swift" "json" "lua" "nix"];
      command = "setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab";
    }

    # Metals (Scala) - Refresh codelens
    {
      event = ["BufEnter" "CursorHold" "InsertLeave"];
      pattern = ["*.scala" "*.sbt" "*.java"];
      command = "lua vim.lsp.codelens.refresh()";
    }
  ];
}
