# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a nix-darwin and home-manager configuration for managing a macOS system (Apple Silicon M3 Max) declaratively. The configuration uses Nix flakes and manages both system-level packages (via nix-darwin) and user-level packages and dotfiles (via home-manager).

## Architecture

### Flake Structure

The repository follows a modular architecture:

- **`flake.nix`**: Entry point defining inputs (nixpkgs, nix-darwin, home-manager, nur) and outputs. Defines the main darwin configuration `salarm3max` for aarch64-darwin.
- **`home.nix`**: Main home-manager configuration importing all program modules and defining system-wide packages.
- **`programs/default.nix`**: List of program module imports (each program has its own subdirectory with `default.nix`).
- **`programs/*/default.nix`**: Individual program configurations (fish, git, jujutsu, ghostty, nixvim, zed, etc.).

### Key Design Patterns

1. **Modular Program Configuration**: Each program (fish, git, ghostty, etc.) has its own directory under `programs/` with a `default.nix` file.
2. **Allowlist for Unfree Packages**: Unfree packages are explicitly allowlisted in `home.nix` using `allowUnfreePredicate`.
3. **Nixvim Configuration**: Neovim is configured via nixvim in `programs/nixvim/` with modular plugin configurations.
4. **Integration Through Imports**: `programs/default.nix` is a simple list that gets imported into `home.nix`, making it easy to enable/disable programs.

## Common Commands

**Note**: User uses Fish shell, not Bash. All commands below work in Fish.

### Building and Activating Configuration

```fish
# Build and switch to new configuration (PREFERRED - use this alias)
nixre

# Full command (if needed)
darwin-rebuild switch --flake ~/.config/nixpkgs#salarm3max

# Build without switching
darwin-rebuild build --flake ~/.config/nixpkgs#salarm3max
```

### Updating Dependencies

```fish
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
```

### Testing Changes

```fish
# Build configuration locally to test before switching
nix build .#darwinConfigurations.salarm3max.system
```

### Maintenance

```fish
# Garbage collection
nix-collect-garbage -d  # Also aliased as: nixgc

# Repair Nix store
nix-store --repair --verify --check-contents  # Also aliased as: nixstorerepair

# Check system info
nix-shell -p nix-info --run "nix-info -m"  # Also aliased as: nixinfo
```

## Adding New Programs

To add a new program configuration:

1. Create directory: `programs/newprogram/`
2. Create `programs/newprogram/default.nix` with configuration
3. Add `./newprogram` to the list in `programs/default.nix`
4. Run `nixre` to apply changes

## Important Notes

- **Platform**: This configuration is specifically for `aarch64-darwin` (Apple Silicon Macs).
- **User**: Configuration is for user `salar` with home directory `/Users/salar`.
- **Shell**: Fish is the default shell with extensive customizations.
- **Nix Features**: Experimental features `nix-command` and `flakes` are enabled.
- **Version Control**: Uses jujutsu (jj) as the primary VCS alongside git.
- **Editor**: Neovim is the default editor (`$EDITOR` and `$VISUAL` environment variables).
