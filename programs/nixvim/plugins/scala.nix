{ pkgs, ... }:

{
  # Add nvim-metals plugin for DAP support and additional Metals features
  programs.nixvim.extraPlugins = [
    pkgs.vimPlugins.nvim-metals
  ];

  programs.nixvim.plugins = {
    # DAP (Debug Adapter Protocol) support
    dap = {
      enable = true;

      # Scala debugging signs
      signs = {
        dapBreakpoint = {
          text = "●";
          texthl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "◆";
          texthl = "DapBreakpoint";
        };
        dapBreakpointRejected = {
          text = "○";
          texthl = "DapBreakpoint";
        };
        dapLogPoint = {
          text = "◆";
          texthl = "DapLogPoint";
        };
        dapStopped = {
          text = "→";
          texthl = "DapStopped";
        };
      };
    };

    # DAP UI - now a top-level plugin
    dap-ui = {
      enable = true;
      # Automatically open/close DAP UI
      settings.floating.mappings.close = [ "<Esc>" "q" ];
    };

    # DAP Virtual Text - now a top-level plugin
    dap-virtual-text.enable = true;
  };

  # DAP keybindings for Scala debugging
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>db";
      action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
      options = {
        silent = true;
        desc = "Toggle breakpoint";
      };
    }
    {
      mode = "n";
      key = "<leader>dc";
      action = "<cmd>lua require('dap').continue()<CR>";
      options = {
        silent = true;
        desc = "Continue debugging";
      };
    }
    {
      mode = "n";
      key = "<leader>ds";
      action = "<cmd>lua require('dap').step_over()<CR>";
      options = {
        silent = true;
        desc = "Step over";
      };
    }
    {
      mode = "n";
      key = "<leader>di";
      action = "<cmd>lua require('dap').step_into()<CR>";
      options = {
        silent = true;
        desc = "Step into";
      };
    }
    {
      mode = "n";
      key = "<leader>do";
      action = "<cmd>lua require('dap').step_out()<CR>";
      options = {
        silent = true;
        desc = "Step out";
      };
    }
    {
      mode = "n";
      key = "<leader>dt";
      action = "<cmd>lua require('dap').terminate()<CR>";
      options = {
        silent = true;
        desc = "Terminate debugging";
      };
    }
    {
      mode = "n";
      key = "<leader>du";
      action = "<cmd>lua require('dapui').toggle()<CR>";
      options = {
        silent = true;
        desc = "Toggle DAP UI";
      };
    }
    {
      mode = "n";
      key = "<leader>dh";
      action = "<cmd>lua require('dap.ui.widgets').hover()<CR>";
      options = {
        silent = true;
        desc = "Hover variable value";
      };
    }
  ];

  # Metals DAP initialization
  programs.nixvim.extraConfigLua = ''
    -- Setup Metals DAP adapter
    local dap = require('dap')

    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "Run or Test Target",
        metals = {
          runType = "runOrTestFile",
        },
      },
      {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
          runType = "testTarget",
        },
      },
    }

    -- Automatically setup DAP when Metals attaches
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt", "sc" },
      callback = function()
        local ok, metals = pcall(require, "metals")
        if ok and metals.setup_dap then
          metals.setup_dap()
        end
      end,
    })
  '';
}
