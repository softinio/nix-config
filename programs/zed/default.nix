{ ... }:
{
  programs.zed-editor = {
    enable = true;
    userSettings = {
      agent_servers = {
        "github-copilot-cli" = {
          type = "registry";
        };
        "claude-acp" = {
          type = "registry";
        };
      };
      edit_predictions = {
        provider = "copilot";
      };
      agent = {
        single_file_review = true;
        use_modifier_to_send = true;
        thinking_display = "always_collapsed";
        enable_feedback = false;
        dock = "right";
        default_model = {
          model = "claude-sonnet-4-6";
          provider = "copilot_chat";
        };
      };
      auto_install_extensions = {
        fish = true;
        java = true;
        lua = true;
        nix = true;
        pyrefly = true;
        ruff = true;
        scala = true;
        sql = true;
        swift = true;
        toml = true;
        zig = true;
        http = true;
        python = true;
        markdown = true;
        opentofu = true;
        typescript = true;
      };
      auto_update = false;
      autosave = "on_focus_change";
      language_models = {
        anthropic = {
          available_models = [
            {
              cache_configuration = {
                max_cache_anchors = 10;
                min_total_token = 10000;
                should_speculate = false;
              };
              max_tokens = 200000;
              name = "claude-sonnet-4-6";
            }
          ];
        };
        openai = {
          available_models = [
            {
              display_name = "gpt-5.2-codex";
              max_completion_tokens = 20000;
              max_tokens = 272000;
              name = "gpt-5.2-codex";
              reasoning_effort = "high";
            }
          ];
        };
      };
      load_direnv = "shell_hook";
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      terminal = {
        copy_on_select = true;
        dock = "bottom";
      };
      theme = "Ayu Dark";
      vim_mode = true;
      auto_signature_help = true;
      show_signature_help_after_edits = true;
    };
    userTasks = [
      {
        label = "Run HTTP Request";
        command = "httpyac";
        args = [ "send" "--line" "$ZED_ROW" "$ZED_FILE" ];
        tags = [ "http-request" ];
        reveal = "always";
      }
      {
        label = "Run All HTTP Requests";
        command = "httpyac";
        args = [ "send" "$ZED_FILE" ];
        tags = [ "http-request" ];
        reveal = "always";
      }
    ];
  };
}
