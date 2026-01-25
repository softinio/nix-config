{ pkgs, ... }:

{
  programs.nixvim = {
    plugins = {
      # GitHub Copilot (using copilot-lua to avoid npm runtime installs)
      copilot-lua = {
        enable = true;
        settings = {
          suggestion = {
            enabled = true;
            auto_trigger = true;
            keymap = {
              accept = "<C-J>";
              accept_word = "<C-Right>";
              accept_line = "<C-Down>";
              next = "<M-]>";
              prev = "<M-[>";
              dismiss = "<C-]>";
            };
          };
          panel.enabled = false;
          copilot_node_command = "${pkgs.nodejs}/bin/node";
        };
      };

      # Avante AI assistant (imported from separate file)
      # avante config is in avante.nix
    };
  };
}
