# nix-config

My Nix Configuration for macOS using nix-darwin and home-manager.

Supports both Apple Silicon and Intel Macs, with multi-user support for shared machines.

## Quick Start

```bash
# First time setup (after installing Nix)
nix run nix-darwin -- switch --flake ~/.config/nixpkgs#<config-name>

# Subsequent rebuilds
darwin-rebuild switch --flake ~/.config/nixpkgs#<config-name>
```

Available configurations: `salarm3max` (Apple Silicon), `salarintel` (Intel)

## User Profiles

User-specific settings (name, email, etc.) are stored in `users/*.nix` files.

Example user profile (`users/myusername.nix`):

```nix
{
  username = "myusername";
  fullName = "My Full Name";
  email = "me@example.com";
  gitSigningKey = "~/.ssh/id_ed25519.pub";  # or null if not using signing
  jujutsuBranchPrefix = "myprefix";

  # Optional: wezterm SSH domains (omit if not needed)
  weztermSshDomains = [
    {
      name = "myserver";
      remoteAddress = "myserver.example.com";
      username = "myusername";
      remoteWeztermPath = "/run/current-system/sw/bin/wezterm";
    }
  ];

  # Optional: wezterm workspace switcher entries (omit if not needed)
  weztermWorkspaces = [
    { id = "";          label = "Home"; }
    { id = "/Projects"; label = "My Projects"; }
  ];
}
```

Then reference it in your machine configuration in `flake.nix`:

```nix
myMachine = mkDarwinConfig {
  system = "aarch64-darwin";
  hostname = "my-machine";
  users = [ (import ./users/myusername.nix) ];
};
```

For shared machines with multiple users:

```nix
sharedMachine = mkDarwinConfig {
  system = "aarch64-darwin";
  hostname = "shared-machine";
  users = [
    (import ./users/user1.nix)
    (import ./users/user2.nix)
  ];
};
```

## Documentation

See [CLAUDE.md](./CLAUDE.md) for detailed documentation on:
- Repository architecture and structure
- Adding new programs
- Adding new machine configurations
- Common commands and aliases
- Customization options
