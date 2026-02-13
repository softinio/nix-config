{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;

    # Use Tango Dark theme (similar to ghostty's "Builtin Tango Dark")
    theme = "tokyo_night";

    settings = {
      # Window settings
      window = {
        decorations = "transparent";
        opacity = 1.0;
        startup_mode = "Maximized";
        dynamic_padding = true;
      };

      # Font configuration (matching ghostty)
      font = {
        normal = {
          family = "SF Mono";
          style = "Regular";
        };
        bold = {
          family = "SF Mono";
          style = "Bold";
        };
        italic = {
          family = "SF Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "SF Mono";
          style = "Bold Italic";
        };
        size = 16;
      };

      # Cursor
      cursor = {
        style = {
          shape = "Block";
          blinking = "Off";
        };
      };

      # Mouse settings (matching ghostty's mouse-hide-while-typing)
      mouse = {
        hide_when_typing = true;
      };

      # Selection settings (matching ghostty's copy-on-select)
      selection = {
        save_to_clipboard = true;
      };

      # Working directory
      general.working_directory = "Home";

      # Keyboard bindings (matching ghostty keybinds as closely as possible)
      keyboard.bindings = [
        # Shift+Enter sends newline (matching ghostty's shift+enter=text:\n)
        {
          key = "Return";
          mods = "Shift";
          chars = "\\n";
        }

        # Note: Alacritty doesn't have built-in window splitting like ghostty.
        # For split functionality, you would typically use tmux or another terminal multiplexer.
        # The following keybindings from ghostty cannot be directly replicated:
        # - super+k (toggle_split_zoom)
        # - super+b>' (new_split:right)
        # - super+b>- (new_split:down)

        # Additional useful keybindings
        {
          key = "K";
          mods = "Command";
          action = "ClearHistory";
        }
        {
          key = "N";
          mods = "Command";
          action = "CreateNewWindow";
        }
      ];
    };
  };
}
