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

    # Enable word wrap for markdown
    {
      event = "FileType";
      pattern = "markdown";
      command = "setlocal wrap linebreak";
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

    # Kulala REST client keymaps (only active in .http files)
    {
      event = "FileType";
      pattern = "http";
      callback.__raw = ''
        function()
          local opts = { buffer = true }
          vim.keymap.set("n", "<leader>Rs", function() require("kulala").run() end, vim.tbl_extend("force", opts, { desc = "Kulala: Send request" }))
          vim.keymap.set("n", "<leader>Ra", function() require("kulala").run_all() end, vim.tbl_extend("force", opts, { desc = "Kulala: Send all requests" }))
          vim.keymap.set("n", "<leader>Rr", function() require("kulala").replay() end, vim.tbl_extend("force", opts, { desc = "Kulala: Replay last request" }))
          vim.keymap.set("n", "<leader>Rf", function() require("kulala").search() end, vim.tbl_extend("force", opts, { desc = "Kulala: Find request" }))
        end
      '';
    }

  ];
}
