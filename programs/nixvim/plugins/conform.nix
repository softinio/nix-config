{ ... }:

{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          json = [ "prettier" ];
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          python.__raw = ''
            function(bufnr)
              if require("conform").get_formatter_info("ruff_format", bufnr).available then
                return { "ruff_fix", "ruff_format" }
              else
                return { "isort", "black", "flake8" }
              end
            end
          '';
          scala = [ "scalafmt" ];
          swift = [ "swift" ];
          zig = [ "zigfmt" ];
          "*" = [
            "trim_whitespace"
            "trim_newlines"
          ];
        };
        format_on_save.__raw = ''
          function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            -- Skip scala files, they use format_after_save due to slow JVM startup
            if vim.bo[bufnr].filetype == "scala" then
              return
            end
            return { timeout_ms = 500, lsp_fallback = true }
          end
        '';
        format_after_save.__raw = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            -- Only use format_after_save for scala (scalafmt is slow)
            if vim.bo[bufnr].filetype == "scala" then
              return { lsp_fallback = true }
            end
          end
        '';
      };
    };
  };
}
