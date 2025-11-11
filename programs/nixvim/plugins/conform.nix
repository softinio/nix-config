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
          python = ''
            function(bufnr)
              if require("conform").get_formatter_info("ruff_format", bufnr).available then
                return { "ruff_fix", "ruff_format" }
              else
                return { "isort", "black", "flake8" }
              end
            end
          '';
          scala = [ "scalafmt" ];
          swift = [ "swift_format" ];
          zig = [ "zigfmt" ];
          "*" = [
            "trim_whitespace"
            "trim_newlines"
          ];
        };
        format_on_save = ''
          function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_fallback = true }
          end
        '';
      };
    };
  };
}
