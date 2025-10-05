{ ... }:

{
  programs.nixvim.lsp.keymaps = [
    # Diagnostics navigation
    {
      key = "<leader>k";
      action.__raw = "function() vim.diagnostic.jump({ count=-1, float=true }) end";
    }
    {
      key = "<leader>j";
      action.__raw = "function() vim.diagnostic.jump({ count=1, float=true }) end";
    }

    # LSP navigation
    {
      key = "gd";
      lspBufAction = "definition";
    }
    {
      key = "gD";
      lspBufAction = "references";
    }
    {
      key = "gt";
      lspBufAction = "type_definition";
    }
    {
      key = "gi";
      lspBufAction = "implementation";
    }

    # Documentation and refactoring
    {
      key = "K";
      lspBufAction = "hover";
    }
    {
      key = "<F2>";
      lspBufAction = "rename";
    }
  ];
}