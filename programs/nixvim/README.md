# Nixvim Configuration

This directory contains a modular Neovim configuration managed through [nixvim](https://github.com/nix-community/nixvim).

## Directory Structure

```
nixvim/
├── default.nix           # Main entry point
├── options.nix           # Core Neovim options (line numbers, tabs, etc.)
├── keymappings.nix       # Global key mappings
├── autocommands.nix      # Auto commands for various events
├── completion.nix        # Completion configuration (nvim-cmp)
└── plugins/              # Plugin configurations
    ├── default.nix       # Plugin imports
    ├── ui.nix            # UI enhancements (colorscheme, icons, etc.)
    ├── git.nix           # Git integration
    ├── editing.nix       # Editing enhancements
    ├── utility.nix       # Utility plugins
    ├── ai.nix            # AI assistants (Copilot, Avante)
    ├── lsp/              # Language Server Protocol
    │   ├── default.nix   # LSP imports
    │   ├── servers.nix   # Language server configurations
    │   ├── keymaps.nix   # LSP-specific key mappings
    │   └── formatting.nix # Auto-formatting settings
    ├── avante.nix        # Avante AI configuration
    ├── conform.nix       # Code formatting
    ├── floaterm.nix      # Floating terminal
    ├── lualine.nix       # Status line
    ├── neo-tree.nix      # File explorer
    ├── telescope.nix     # Fuzzy finder
    └── treesitter.nix    # Syntax highlighting
```

## Configuration Categories

### Core Settings (`options.nix`)
- Editor options (line numbers, indentation, etc.)
- Update time and performance settings
- Clipboard configuration
- Leader key mappings

### Key Mappings (`keymappings.nix`)
- Window navigation
- Buffer management
- Text manipulation
- Custom shortcuts

### Auto Commands (`autocommands.nix`)
- FileType-specific settings
- Auto-formatting rules
- UI behavior modifications

### Completion (`completion.nix`)
- nvim-cmp configuration
- Snippet support
- LSP integration
- Multiple completion sources

### Plugins

#### UI Enhancements (`ui.nix`)
- **Colorscheme**: Tokyo Night theme with custom background
- **Icons**: File type icons via web-devicons
- **Visual aids**: Indent guides, color highlighting, markdown preview

#### Git Integration (`git.nix`)
- **Gitsigns**: Shows git changes in the gutter

#### Editing (`editing.nix`)
- **Auto-pairs**: Automatic bracket/quote closing
- **Flash**: Enhanced jump/search
- **Trim**: Whitespace management
- **Image support**: Clipboard image pasting

#### Utilities (`utility.nix`)
- **Oil**: File manager
- **Todo-comments**: Highlight TODO/FIXME comments
- **Trouble**: Diagnostics list
- **Which-key**: Show available keybindings

#### AI Assistants (`ai.nix`)
- **Copilot**: GitHub Copilot integration
- **Avante**: Advanced AI assistant

#### LSP (`lsp/`)
- **Language Servers**: Support for 15+ languages
- **Key mappings**: Go-to-definition, references, hover docs
- **Auto-formatting**: Format on save for all supported languages

## Adding New Configurations

### Adding a New Plugin

1. Create a new file in `plugins/` or add to an existing category file
2. Add the import to `plugins/default.nix`
3. Configure the plugin following nixvim documentation

Example:
```nix
# plugins/my-plugin.nix
{ ... }:
{
  programs.nixvim.plugins.my-plugin = {
    enable = true;
    settings = {
      # Plugin-specific settings
    };
  };
}
```

### Adding a New Language Server

Edit `plugins/lsp/servers.nix` and add your server configuration:
```nix
my_language_ls = {
  enable = true;
  settings = {
    # Server-specific settings
  };
};
```

### Adding Key Mappings

- **Global mappings**: Add to `keymappings.nix`
- **LSP mappings**: Add to `plugins/lsp/keymaps.nix`
- **Plugin-specific**: Add to the plugin's configuration file

## Applying Changes

After making changes, rebuild your nix configuration:
```bash
nixre  # Alias for darwin-rebuild switch --flake ~/.config/nixpkgs#salarm3max
```

## Performance Tuning

Key performance settings:
- `updatetime`: Controls LSP/diagnostic update speed (currently 100ms)
- `performance.debounce`: Completion debounce time (60ms)
- `performance.throttle`: Completion throttle time (30ms)

Adjust these in `options.nix` and `completion.nix` respectively.

## Troubleshooting

### LSP Not Working
1. Check if language server is installed: `:LspInfo`
2. Verify keymaps are loaded: `:map gd`
3. Check for errors: `:messages`

### Slow Performance
1. Increase `updatetime` in `options.nix`
2. Adjust completion performance settings in `completion.nix`
3. Disable unused language servers in `lsp/servers.nix`

## Resources

- [Nixvim Documentation](https://nix-community.github.io/nixvim/)
- [Neovim Documentation](https://neovim.io/doc/)
- [LSP Specification](https://microsoft.github.io/language-server-protocol/)