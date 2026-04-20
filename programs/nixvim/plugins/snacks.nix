{ ... }:

{
  programs.nixvim = {
    plugins.snacks = {
      enable = true;
      settings = {
        bigfile.enabled = true;
        explorer.enabled = true;
        image.enabled = true;
        indent.enabled = true;
        lazygit.enabled = true;
        notifier.enabled = true;
        picker = {
          enabled = true;
          layout = "ivy";
          live = true;
          matcher = {
            frecency = false;
            filename_bonus = false;
          };
        };
        quickfile.enabled = true;
        scroll.enabled = true;
        statuscolumn.enabled = true;
        words.enabled = true;
      };
    };

    keymaps = [
      # Explorer (replaces neo-tree)
      {
        mode = "n";
        key = "<leader>m";
        action.__raw = ''function() Snacks.explorer({ layout = { layout = { position = "right" } } }) end'';
        options = {
          silent = true;
          desc = "Toggle Explorer";
        };
      }

      # Picker (replaces telescope)
      {
        mode = "n";
        key = "<leader>ff";
        action.__raw = "function() Snacks.picker.files({ live = false }) end";
        options = {
          silent = true;
          desc = "Find Files";
        };
      }
      {
        mode = "n";
        key = "<leader>fb";
        action.__raw = "function() Snacks.picker.buffers() end";
        options = {
          silent = true;
          desc = "Buffers";
        };
      }
      {
        mode = "n";
        key = "<leader>fg";
        action.__raw = "function() Snacks.picker.grep() end";
        options = {
          silent = true;
          desc = "Live Grep";
        };
      }
      {
        mode = "n";
        key = "<leader>fh";
        action.__raw = "function() Snacks.picker.help() end";
        options = {
          silent = true;
          desc = "Help Tags";
        };
      }
      {
        mode = "n";
        key = "<leader>fd";
        action.__raw = "function() Snacks.picker.diagnostics() end";
        options = {
          silent = true;
          desc = "Diagnostics";
        };
      }
      {
        mode = "n";
        key = "<C-p>";
        action.__raw = "function() Snacks.picker.git_files() end";
        options = {
          silent = true;
          desc = "Git Files";
        };
      }
      {
        mode = "n";
        key = "<leader>?";
        action.__raw = "function() Snacks.picker.recent() end";
        options = {
          silent = true;
          desc = "Recent Files";
        };
      }
      {
        mode = "n";
        key = "<C-t>";
        action.__raw = ''
          function()
            Snacks.picker.grep({
              search = "TODO",
              initial_mode = "normal"
            })
          end
        '';
        options = {
          silent = true;
          desc = "Search TODOs";
        };
      }

      # Picker extras
      {
        mode = "n";
        key = "<leader>fw";
        action.__raw = "function() Snacks.picker.grep_word() end";
        options = { silent = true; desc = "Grep Word Under Cursor"; };
      }
      {
        mode = "n";
        key = "<leader>fs";
        action.__raw = "function() Snacks.picker.lsp_symbols() end";
        options = { silent = true; desc = "LSP Symbols (file)"; };
      }
      {
        mode = "n";
        key = "<leader>fS";
        action.__raw = "function() Snacks.picker.lsp_workspace_symbols() end";
        options = { silent = true; desc = "LSP Symbols (workspace)"; };
      }
      {
        mode = "n";
        key = "<leader>fk";
        action.__raw = "function() Snacks.picker.keymaps() end";
        options = { silent = true; desc = "Keymaps"; };
      }
      {
        mode = "n";
        key = "<leader>fc";
        action.__raw = "function() Snacks.picker.commands() end";
        options = { silent = true; desc = "Commands"; };
      }
      {
        mode = "n";
        key = "<leader>fm";
        action.__raw = "function() Snacks.picker.marks() end";
        options = { silent = true; desc = "Marks"; };
      }
      {
        mode = "n";
        key = "<leader>fj";
        action.__raw = "function() Snacks.picker.jumps() end";
        options = { silent = true; desc = "Jumps"; };
      }

      # Git
      {
        mode = "n";
        key = "<leader>gl";
        action.__raw = "function() Snacks.picker.git_log() end";
        options = { silent = true; desc = "Git Log"; };
      }
      {
        mode = "n";
        key = "<leader>gb";
        action.__raw = "function() Snacks.picker.git_branches() end";
        options = { silent = true; desc = "Git Branches"; };
      }
      {
        mode = "n";
        key = "<leader>gs";
        action.__raw = "function() Snacks.picker.git_status() end";
        options = { silent = true; desc = "Git Status"; };
      }
      {
        mode = "n";
        key = "<leader>lg";
        action.__raw = "function() Snacks.lazygit() end";
        options = { silent = true; desc = "LazyGit"; };
      }
      {
        mode = "n";
        key = "<leader>lf";
        action.__raw = "function() Snacks.lazygit.log_file() end";
        options = { silent = true; desc = "LazyGit File Log"; };
      }
      {
        mode = "n";
        key = "<leader>gB";
        action.__raw = "function() Snacks.gitbrowse() end";
        options = { silent = true; desc = "Git Browse"; };
      }

      # Notifier
      {
        mode = "n";
        key = "<leader>nh";
        action.__raw = "function() Snacks.notifier.show_history() end";
        options = { silent = true; desc = "Notification History"; };
      }

      # Words (LSP reference navigation)
      {
        mode = "n";
        key = "]]";
        action.__raw = "function() Snacks.words.jump(1) end";
        options = { silent = true; desc = "Next LSP Reference"; };
      }
      {
        mode = "n";
        key = "[[";
        action.__raw = "function() Snacks.words.jump(-1) end";
        options = { silent = true; desc = "Prev LSP Reference"; };
      }
    ];
  };
}
