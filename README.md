# nix-config

My Nix Configuration for macOS using nix-darwin and home-manager.

Supports both Apple Silicon and Intel Macs.

## Quick Start

```bash
# First time setup (after installing Nix)
nix run nix-darwin -- switch --flake ~/.config/nixpkgs#<config-name>

# Subsequent rebuilds
darwin-rebuild switch --flake ~/.config/nixpkgs#<config-name>
```

Available configurations: `salarm3max` (Apple Silicon), `salarintel` (Intel)

## Documentation

See [CLAUDE.md](./CLAUDE.md) for detailed documentation on:
- Repository architecture and structure
- Adding new programs
- Adding new machine configurations
- Common commands and aliases
- Customization options
