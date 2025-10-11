{ pkgs, lib, ... }:

{
  programs.nixvim = {
    plugins = {
      # GitHub Copilot
      copilot-vim = {
        enable = true;
      };

      # Avante AI assistant (imported from separate file)
      # avante config is in avante.nix
    };

    globals = {
      copilot_node_command = lib.mkForce "${pkgs.nodejs}/bin/node";
      copilot_no_tab_map = true;
      copilot_assume_mapped = true;
    };

    # Copilot keymapping - use Ctrl+J to accept suggestion
    keymaps = [
      {
        mode = "i";
        key = "<C-J>";
        action = "copilot#Accept(\"\\<CR>\")";
        options = {
          silent = true;
          script = true;
          expr = true;
          replace_keycodes = false;
        };
      }
    ];
  };
}
