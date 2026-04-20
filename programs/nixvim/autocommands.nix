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
        "*.mills"
      ];
      command = "lua vim.lsp.codelens.refresh()";
    }

    # Python: disable pylsp formatting/linting plugins when the project uses ruff
    {
      event = "LspAttach";
      callback.__raw = ''
        function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          local function has_ruff()
            if #vim.fs.find({ "ruff.toml", ".ruff.toml" }, {
              upward = true,
              path = vim.fn.expand("%:p:h"),
            }) > 0 then
              return true
            end
            local pyproject = vim.fs.find("pyproject.toml", {
              upward = true,
              path = vim.fn.expand("%:p:h"),
            })
            if #pyproject > 0 then
              for _, line in ipairs(vim.fn.readfile(pyproject[1])) do
                if line:match("%[tool%.ruff%]") then return true end
              end
            end
            return false
          end

          -- Stop ruff LSP when the project does not use ruff
          if client.name == "ruff" and not has_ruff() then
            client.stop()
            return
          end

          -- Disable pylsp formatting/linting plugins when ruff is present
          if client.name == "pylsp" and has_ruff() then
            client.config.settings = vim.tbl_deep_extend("force",
              client.config.settings or {}, {
                pylsp = {
                  plugins = {
                    black  = { enabled = false },
                    isort  = { enabled = false },
                    flake8 = { enabled = false },
                  },
                },
              }
            )
            client.notify("workspace/didChangeConfiguration",
              { settings = client.config.settings })
          end
        end
      '';
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
