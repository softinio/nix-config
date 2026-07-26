{
  description = "Nix and home-manager configurations for Softinio's macbook";

  inputs = {
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NOTE: hunk is a flake-parts flake that enumerates x86_64-darwin in its
    # perSystem outputs (evaluated via `self'` in its home-manager module).
    # It must NOT follow our unstable nixpkgs (26.11+ dropped x86_64-darwin),
    # or evaluation throws even on aarch64. Pin it to the 26.05-darwin branch,
    # which still supports Intel.
    hunk = {
      url = "github:modem-dev/hunk";
      inputs.nixpkgs.follows = "nixpkgs-x86-compat";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs-unstable (26.11+) dropped x86_64-darwin support. Some flake-parts
    # inputs (e.g. hunk) enumerate x86_64-darwin in their perSystem outputs and
    # would throw when following our unstable nixpkgs. Pin such inputs to the
    # 26.05-darwin stable branch, which still supports Intel Macs.
    nixpkgs-x86-compat.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
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
      hunk,
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
                  inherit hunk;
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
