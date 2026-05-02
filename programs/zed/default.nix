{ ... }:
{
  programs.zed-editor = {
    enable = true;
    userSettings = {
      project_panel = {
        dock = "left";
      };
      outline_panel = {
        dock = "left";
      };
      collaboration_panel = {
        dock = "left";
      };
      git_panel = {
        dock = "left";
      };
      agent = {
        dock = "right";
        default_model = {
          model = "claude-sonnet-4-6";
          provider = "copilot_chat";
        };
      };
      agent_servers = {
        "github-copilot-cli" = {
          type = "registry";
        };
        "claude-acp" = {
          type = "registry";
        };
      };
      auto_install_extensions = {
        fish = true;
        http = true;
        lua = true;
        markdown = true;
        nix = true;
        opentofu = true;
        pyrefly = true;
        python = true;
        ruff = true;
        scala = true;
        sql = true;
        swift = true;
        toml = true;
        typescript = true;
        zig = true;
      };
      auto_signature_help = true;
      edit_predictions = {
        provider = "copilot";
      };
      autosave = "on_focus_change";
      auto_update = false;
      language_models = {
        anthropic = {
          available_models = [
            {
              name = "claude-sonnet-4-6";
              max_tokens = 200000;
              cache_configuration = {
                max_cache_anchors = 10;
                min_total_token = 10000;
                should_speculate = false;
              };
            }
          ];
        };
        openai = {
          available_models = [
            {
              name = "gpt-5.2-codex";
              display_name = "gpt-5.2-codex";
              reasoning_effort = "high";
              max_tokens = 272000;
              max_completion_tokens = 20000;
            }
          ];
        };
      };
      load_direnv = "shell_hook";
      show_signature_help_after_edits = true;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      terminal = {
        copy_on_select = true;
        dock = "bottom";
      };
      theme = "Gruvbox Light";
      vim_mode = true;
    };
  };
}
