# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a nix-darwin and home-manager configuration for managing macOS systems declaratively. The configuration uses Nix flakes and manages both system-level packages (via nix-darwin) and user-level packages and dotfiles (via home-manager).

Supports both Apple Silicon (`aarch64-darwin`) and Intel (`x86_64-darwin`) Macs, with multi-user support for shared machines.

## Architecture

### Flake Structure

The repository follows a modular architecture:

- **`flake.nix`**: Entry point defining inputs (nixpkgs, nix-darwin, home-manager, nur) and outputs. Uses `mkDarwinConfig` helper function to generate machine configurations.
- **`home.nix`**: Main home-manager configuration importing all program modules and defining system-wide packages. Receives `user` argument for user-specific settings.
- **`users/*.nix`**: User profile files containing personal settings (gitignored to keep private).
- **`programs/default.nix`**: List of program module imports (each program has its own subdirectory with `default.nix`).
- **`programs/*/default.nix`**: Individual program configurations (fish, git, jujutsu, ghostty, nixvim, zed, etc.). Can access `user` argument for user-specific settings.

### User Profiles

User-specific settings are defined in `users/*.nix` files.

User profile structure:

```nix
{
  username = "myusername";           # Unix username
  fullName = "My Full Name";         # Used in git, jujutsu, darcs, pijul
  email = "me@example.com";          # Used in git, jujutsu, darcs, pijul
  gitSigningKey = "~/.ssh/id_ed25519.pub";  # SSH key for signing (or null)
  jujutsuBranchPrefix = "myprefix";  # Prefix for jujutsu push bookmarks
}
```

### Machine Configuration

The `mkDarwinConfig` function in `flake.nix` generates darwin configurations with these parameters:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `system` | Yes | `"aarch64-darwin"` (Apple Silicon) or `"x86_64-darwin"` (Intel) |
| `hostname` | Yes | Machine hostname (sets `networking.hostName` and `networking.computerName`) |
| `users` | Yes | List of user profiles imported from `./users/*.nix` |

Current configurations in `darwinConfigurations`:
- `salarm3max` - Apple Silicon (M3 Max)
- `salarintel` - Intel Mac (template)

### Key Design Patterns

1. **Modular Program Configuration**: Each program (fish, git, ghostty, etc.) has its own directory under `programs/` with a `default.nix` file.
2. **User Profile System**: User-specific settings (name, email, keys) are defined in gitignored `users/*.nix` files and passed to modules via the `user` argument.
3. **Allowlist for Unfree Packages**: Unfree packages are explicitly allowlisted in `home.nix` using `allowUnfreePredicate`.
4. **Nixvim Configuration**: Neovim is configured via nixvim in `programs/nixvim/` with modular plugin configurations.
5. **Integration Through Imports**: `programs/default.nix` is a simple list that gets imported into `home.nix`, making it easy to enable/disable programs.
6. **Multi-Architecture Support**: The `mkDarwinConfig` function abstracts system-specific details, allowing the same config to work on Intel and Apple Silicon.
7. **Multi-User Support**: A single machine configuration can support multiple users, each with their own home-manager config.

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

## Adding a New User Profile

To add a new user:

1. Create a user profile in `users/`:
   ```nix
   # users/newuser.nix
   {
     username = "newuser";
     fullName = "New User";
     email = "newuser@example.com";
     gitSigningKey = "~/.ssh/id_ed25519.pub";  # or null
     jujutsuBranchPrefix = "newuser";
   }
   ```

2. Add the user to a machine configuration in `flake.nix`

## Adding a New Machine Configuration

To add support for a new machine:

1. Create user profile(s) in `users/` if they don't exist
2. Edit `flake.nix` and add a new entry to `darwinConfigurations`:
   ```nix
   darwinConfigurations = {
     # ... existing configs ...

     # Single user machine
     new-machine = mkDarwinConfig {
       system = "aarch64-darwin";  # or "x86_64-darwin" for Intel
       hostname = "new-machine";
       users = [ (import ./users/myuser.nix) ];
     };

     # Multi-user shared machine
     shared-machine = mkDarwinConfig {
       system = "aarch64-darwin";
       hostname = "shared-machine";
       users = [
         (import ./users/user1.nix)
         (import ./users/user2.nix)
       ];
     };
   };
   ```

3. Build and activate:
   ```fish
   darwin-rebuild switch --flake ~/.config/nixpkgs#new-machine
   ```

## Important Notes

- **Platform**: Supports both `aarch64-darwin` (Apple Silicon) and `x86_64-darwin` (Intel Macs).
- **Users**: User profiles are defined in `users/*.nix` (gitignored). Each machine configuration specifies which users to configure.
- **Shell**: Fish is the default shell with extensive customizations.
- **Nix Features**: Experimental features `nix-command` and `flakes` are enabled.
- **Version Control**: Uses jujutsu (jj) as the primary VCS alongside git.
- **Editor**: Neovim is the default editor (`$EDITOR` and `$VISUAL` environment variables).
