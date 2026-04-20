# Nixvim Configuration

This directory contains a modular Neovim configuration managed through [nixvim](https://github.com/nix-community/nixvim).

## Directory Structure

```
nixvim/
├── default.nix           # Main entry point
├── options.nix           # Core Neovim options (line numbers, tabs, etc.)
├── keymappings.nix       # Global key mappings
├── autocommands.nix      # Auto commands for various events
├── completion.nix        # Completion configuration (native LSP)
└── plugins/              # Plugin configurations
    ├── default.nix       # Plugin imports
    ├── ui.nix            # UI enhancements (colorscheme, icons, etc.)
    ├── vcs.nix           # VCS integration
    ├── editing.nix       # Editing enhancements
    ├── utility.nix       # Utility plugins
    ├── ai.nix            # AI assistants (Copilot, Avante)
    ├── snacks.nix        # Snacks: picker, explorer, lazygit, and more
    ├── lsp/              # Language Server Protocol
    │   ├── default.nix   # LSP imports
    │   ├── servers.nix   # Language server configurations
    │   ├── keymaps.nix   # LSP-specific key mappings
    │   └── formatting.nix # Auto-formatting settings
    ├── avante.nix        # Avante AI configuration
    ├── conform.nix       # Code formatting
    ├── floaterm.nix      # Floating terminal
    ├── lualine.nix       # Status line
    ├── scala.nix         # Scala/Metals debugging (DAP)
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
- Native LSP completion (Neovim 0.12+)
- `completeopt`: menu, menuone, noselect, popup

### Plugins

#### UI Enhancements (`ui.nix`)
- **Colorscheme**: Tokyo Night theme with custom black background and green window separators
- **Icons**: File type icons via web-devicons
- **Color highlighting**: Inline color preview in code
- **Markdown preview**: Live rendering with markview

#### VCS Integration (`vcs.nix`)
- **vim-signify**: Shows VCS changes in the gutter (supports git, darcs, and more)

#### Editing (`editing.nix`)
- **Auto-pairs**: Automatic bracket/quote closing
- **Flash**: Enhanced jump/search navigation
- **Image support**: Clipboard image pasting and inline viewing (img-clip)
- **Zig**: Zig language support

#### Snacks (`snacks.nix`)
All-in-one plugin replacing telescope and neo-tree, plus extras:
- **Explorer**: File tree sidebar (replaces neo-tree), opens on the right
- **Picker**: Fuzzy finder for files, grep, buffers, diagnostics, help, git files, recent files
- **Lazygit**: LazyGit floating window integration
- **Gitbrowse**: Open current file/selection in GitHub/GitLab
- **Indent**: Indent guides with scope highlighting (replaces indent-blankline)
- **Scroll**: Smooth scrolling animations
- **Words**: Auto-highlight LSP symbol references under cursor
- **Bigfile**: Performance optimisation for large files
- **Image**: View images inline in Neovim
- **Notifier**: Fancy notification system
- **Quickfile**: Faster file opening
- **Statuscolumn**: Enhanced gutter with git signs and diagnostics

#### Utilities (`utility.nix`)
- **Todo-comments**: Highlight TODO/FIXME comments
- **Trouble**: Diagnostics list
- **Which-key**: Show available keybindings
- **Kulala**: HTTP REST client for `.http`/`.rest` files

#### Syntax & Language Support (`treesitter.nix`)
- **Treesitter**: Advanced syntax highlighting and code understanding
- **Supported languages**: Scala, Python, Rust, Go, Swift, Zig, TypeScript, JavaScript, Nix, LaTeX, Typst, and 30+ more

#### Scala Development (`scala.nix`)
- **Metals LSP**: Full Scala language server integration
- **DAP Debugging**: Debug Scala applications with breakpoints, step through, and variable inspection
- **Enhanced features**: Inlay hints, code lens, semantic highlighting
- **Build tool support**: sbt, Mill, Maven, Gradle

#### AI Assistants (`ai.nix`)
- **Copilot**: GitHub Copilot integration
- **Avante**: Advanced AI assistant (Claude Sonnet)

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

## Keyboard Shortcuts Cheatsheet

### Leader Key
**Leader:** `Space`

### General Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `Esc` | Normal | Clear search highlighting |
| `Y` | Normal | Yank to end of line |
| `H` | Normal | Go to beginning of line |
| `L` | Normal | Go to end of line |
| `Ctrl-c` | Normal | Switch to alternate buffer |
| `Ctrl-x` | Normal | Close window |
| `Ctrl-s` or `<leader>w` | Normal | Save file |

### Window Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<leader>h` | Normal | Move to left window |
| `<leader>l` | Normal | Move to right window |
| `Ctrl-Up` | Normal | Decrease window height |
| `Ctrl-Down` | Normal | Increase window height |
| `Ctrl-Left` | Normal | Increase window width |
| `Ctrl-Right` | Normal | Decrease window width |

### Text Manipulation

| Key | Mode | Action |
|-----|------|--------|
| `Alt-k` | Normal | Move line up |
| `Alt-j` | Normal | Move line down |
| `>` | Visual | Indent (dot-repeatable) |
| `<` | Visual | Unindent (dot-repeatable) |
| `Tab` | Visual | Indent and keep selection |
| `Shift-Tab` | Visual | Unindent and keep selection |
| `J` | Visual | Move selected lines down |
| `K` | Visual | Move selected lines up |

### File Explorer (Snacks Explorer)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>m` | Normal | Toggle file explorer (right side) |

### Picker (Snacks Picker)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | Normal | Find files (full path search) |
| `<leader>fg` | Normal | Live grep (search text) |
| `<leader>fw` | Normal | Grep word under cursor |
| `<leader>fb` | Normal | List open buffers |
| `<leader>fh` | Normal | Help tags |
| `<leader>fd` | Normal | Diagnostics |
| `<leader>fs` | Normal | LSP symbols (current file) |
| `<leader>fS` | Normal | LSP symbols (workspace) |
| `<leader>fk` | Normal | Browse keymaps |
| `<leader>fc` | Normal | Browse commands |
| `<leader>fm` | Normal | Browse marks |
| `<leader>fj` | Normal | Browse jumplist |
| `Ctrl-p` | Normal | Git files |
| `<leader>?` | Normal | Recently opened files |
| `Ctrl-t` | Normal | Search for TODOs |

### Git

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gl` | Normal | Git log |
| `<leader>gb` | Normal | Git branches |
| `<leader>gs` | Normal | Git status |
| `<leader>lg` | Normal | Open LazyGit |
| `<leader>lf` | Normal | LazyGit file log |
| `<leader>gB` | Normal | Open file in browser (GitHub/GitLab) |

### LSP References (Words)

| Key | Mode | Action |
|-----|------|--------|
| `]]` | Normal | Jump to next LSP reference |
| `[[` | Normal | Jump to previous LSP reference |

### Notifications

| Key | Mode | Action |
|-----|------|--------|
| `<leader>nh` | Normal | Show notification history |

### LSP (Language Server)

| Key | Mode | Action |
|-----|------|--------|
| `gd` | Normal | Go to definition |
| `gD` | Normal | Go to references |
| `gt` | Normal | Go to type definition |
| `gi` | Normal | Go to implementation |
| `K` | Normal | Hover documentation |
| `F2` | Normal | Rename symbol |
| `<leader>j` | Normal | Next diagnostic |
| `<leader>k` | Normal | Previous diagnostic |

### Metals (Scala Development)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mc` | Normal | Metals commands |
| `<leader>mw` | Normal | Hover Metals worksheet |
| `<leader>mt` | Normal | Toggle tree view |
| `<leader>mr` | Normal | Reveal in tree |
| `<leader>mi` | Normal | Organize imports |
| `<leader>mb` | Normal | Build import |
| `<leader>ms` | Normal | Super method hierarchy |
| `<leader>mn` | Normal | New Scala file |
| `<leader>mR` | Normal | Build restart |
| `<leader>mC` | Normal | Build connect |
| `<leader>md` | Normal | Open all diagnostics |

### Scala Debugging (DAP)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>db` | Normal | Toggle breakpoint |
| `<leader>dc` | Normal | Continue debugging |
| `<leader>ds` | Normal | Step over |
| `<leader>di` | Normal | Step into |
| `<leader>do` | Normal | Step out |
| `<leader>dt` | Normal | Terminate debugging |
| `<leader>du` | Normal | Toggle DAP UI |
| `<leader>dh` | Normal | Hover variable value |

### Terminal (Floaterm)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>,` | Normal | Toggle floating terminal |

### AI Assistants

#### Avante
- Enabled with Claude Sonnet model
- Default Avante keybindings apply (check `:help avante` for full list)

#### GitHub Copilot
- Enabled with default keybindings
- Check `:help copilot` for keybinding details

### REST Client (Kulala)

Active only in `.http` / `.rest` files.

| Key | Mode | Action |
|-----|------|--------|
| `<leader>Rs` | Normal | Send request |
| `<leader>Ra` | Normal | Send all requests |
| `<leader>Rr` | Normal | Replay last request |
| `<leader>Rf` | Normal | Find/search requests |

### Other Utilities

| Feature | Command/Key |
|---------|-------------|
| Which-key | Automatically shows available keybindings when you pause |
| Trouble diagnostics | `:Trouble` command |

## Resources

- [Nixvim Documentation](https://nix-community.github.io/nixvim/)
- [Neovim Documentation](https://neovim.io/doc/)
- [LSP Specification](https://microsoft.github.io/language-server-protocol/)
- [Snacks.nvim](https://github.com/folke/snacks.nvim)
