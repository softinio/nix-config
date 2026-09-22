{
  description = "Nix and home-manager configurations for Softinio's macbook";

  inputs = {
    # Promoted to a direct input purely so `nix flake update` keeps it current.
    # herdr's own lock pins an older rust-overlay, and nix seeds transitive inputs
    # from the dependency's lock — without this follows, every `nix flake update`
    # snapped rust-overlay back and reintroduced its stdenv.isDarwin/isLinux
    # deprecation warnings (fixed upstream 2026-08).
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      # Mirrors what herdr already did for it — keeps a second nixpkgs out of the lock.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      herdr,
      nix-darwin,
      nixvim,
      home-manager,
      nixpkgs,
      ...
    }:
    let
      # Helper to make a darwin configuration for a given system
      # Supports multiple users per machine
      mkDarwinConfig =
        {
          system,
          hostname,
          users, # List of user profiles imported from ./users/*.nix
        }:
        let
          usernames = map (u: u.username) users;
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            (
              { pkgs, ... }:
              {
                networking.hostName = hostname;
                networking.computerName = hostname;

                environment.systemPackages = with pkgs; [ home-manager ];

                nix = {
                  nixPath = nixpkgs.lib.mkForce [ "nixpkgs=${nixpkgs}" ];
                  package = pkgs.nixVersions.stable;
                  settings = {
                    experimental-features = "nix-command flakes";
                    # Only Apple Silicon can run x86_64 binaries via Rosetta
                    extra-platforms = nixpkgs.lib.optionals (system == "aarch64-darwin") [
                      "x86_64-darwin"
                    ];
                    trusted-users = [ "root" ] ++ usernames;
                    # Collect garbage mid-build when free space drops below
                    # 10 GiB, stopping once 50 GiB is free.
                    min-free = 10 * 1024 * 1024 * 1024;
                    max-free = 50 * 1024 * 1024 * 1024;
                  };

                  # Saturday disk-space sequence, an hour after the
                  # worktree-audit agent clears .direnv roots at 07:00.
                  # Runs as root via launchd, so it also prunes old system
                  # generations, not just the store.
                  gc = {
                    automatic = true;
                    interval = [
                      {
                        Weekday = 6;
                        Hour = 8;
                        Minute = 0;
                      }
                    ];
                    options = "--delete-older-than 14d";
                  };

                  # auto-optimise-store is known to corrupt the store on darwin;
                  # a scheduled `nix-store --optimise` is the safe alternative.
                  # An hour after the GC so it does not dedupe paths that are
                  # about to be deleted.
                  optimise = {
                    automatic = true;
                    interval = [
                      {
                        Weekday = 6;
                        Hour = 9;
                        Minute = 0;
                      }
                    ];
                  };
                };

                programs.fish.enable = true;

                system.activationScripts.linkGhosttyIntegrationForCmux.text =
                  let
                    firstUser = builtins.head users;
                  in
                  ''
                    GHOSTTY_BIN=$(readlink -f /etc/profiles/per-user/${firstUser.username}/bin/ghostty 2>/dev/null || true)
                    if [ -n "$GHOSTTY_BIN" ]; then
                      GHOSTTY_STORE_DIR=$(dirname $(dirname "$GHOSTTY_BIN"))
                      GHOSTTY_INTEGRATION="$GHOSTTY_STORE_DIR/Applications/Ghostty.app/Contents/Resources/ghostty/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
                      if [ -f "$GHOSTTY_INTEGRATION" ]; then
                        mkdir -p "/Applications/cmux.app/Contents/Resources/ghostty/shell-integration/fish/vendor_conf.d"
                        ln -sfn "$GHOSTTY_INTEGRATION" "/Applications/cmux.app/Contents/Resources/ghostty/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
                      fi
                    fi
                  '';

                system.configurationRevision = self.rev or self.dirtyRev or null;
                system.stateVersion = 4;

                nixpkgs.hostPlatform = system;

                users.users = builtins.listToAttrs (
                  map (user: {
                    name = user.username;
                    value = {
                      home = "/Users/${user.username}";
                    };
                  }) users
                );
              }
            )
            home-manager.darwinModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useUserPackages = true;
              home-manager.users = builtins.listToAttrs (
                map (user: {
                  name = user.username;
                  value =
                    { ... }:
                    {
                      imports = [ ./home.nix ];
                      _module.args.user = user;
                    };
                }) users
              );
              home-manager.extraSpecialArgs = {
                inherit hostname;
                inputs = {
                  inherit herdr;
                  inherit nixvim;
                };
              };
            }
          ];
          specialArgs = {
            inherit nixpkgs system users;
          };
        };
    in
    {
      darwinConfigurations = {
        # Apple Silicon Mac (M3 Max)
        salarm3max = mkDarwinConfig {
          system = "aarch64-darwin";
          hostname = "salarm3max";
          users = [ (import ./users/salar.nix) ];
        };

        # Intel Mac (example - update hostname as needed)
        # NOTE: nixpkgs 26.11 (nixpkgs-unstable) dropped x86_64-darwin support.
        # To re-enable Intel, pin a separate nixpkgs input to the
        # nixpkgs-26.05-darwin branch (supported until end of 2026) and wire it
        # through mkDarwinConfig for this configuration.
        # salarintel = mkDarwinConfig {
        #   system = "x86_64-darwin";
        #   hostname = "salarintel";
        #   users = [ (import ./users/salar.nix) ];
        # };
      };

      darwinPackages = self.darwinConfigurations.salarm3max.pkgs;
    };
}
