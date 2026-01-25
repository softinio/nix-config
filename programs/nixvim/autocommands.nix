{ ... }:

{
  programs.nixvim.autoCmd = [
    # Highlight on yank
    {
      event = "TextYankPost";
      pattern = "*";
      command = "lua vim.highlight.on_yank()";
    }

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
      pattern = [
        "swift"
        "json"
        "lua"
        "nix"
      ];
      command = "setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab";
    }

    # Metals (Scala) - Refresh codelens
    {
      event = [
        "BufEnter"
        "CursorHold"
        "InsertLeave"
      ];
      pattern = [
        "*.scala"
        "*.sbt"
        "*.java"
        "*.sc"
      ];
      command = "lua vim.lsp.codelens.refresh()";
    }

    # Scala/sbt file type detection
    {
      event = [
        "BufRead"
        "BufNewFile"
      ];
      pattern = [
        "*.sbt"
        "*.sc"
      ];
      command = "set filetype=scala";
    }

    # Metals-specific settings on attach
    {
      event = "FileType";
      pattern = [
        "scala"
        "sbt"
        "sc"
      ];
      callback.__raw = ''
        function()
          -- Enable semantic tokens for better syntax highlighting
          vim.lsp.semantic_tokens.start()
        end
      '';
    }
  ];
}
