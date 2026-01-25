{
  description = "Nix and home-manager configurations for Softinio's macbook";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/nur";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      nixvim,
      home-manager,
      nur,
      nixpkgs,
      ...
    }:
    let
      # Helper to make a darwin configuration for a given system
      mkDarwinConfig =
        {
          system,
          hostname,
          username ? "salar",
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            (
              { pkgs, ... }:
              {
                networking.hostName = hostname;
                networking.computerName = hostname;

                environment.systemPackages = with pkgs; [ home-manager ];

                fonts.packages = with pkgs; [ fira-code ];

                nix = {
                  nixPath = nixpkgs.lib.mkForce [ "nixpkgs=${nixpkgs}" ];
                  package = pkgs.nixVersions.stable;
                  settings = {
                    experimental-features = "nix-command flakes";
                    # Only Apple Silicon can run x86_64 binaries via Rosetta
                    extra-platforms = nixpkgs.lib.optionals (system == "aarch64-darwin") [
                      "x86_64-darwin"
                    ];
                    trusted-users = [
                      "root"
                      username
                    ];
                  };
                  distributedBuilds = false;
                };

                programs.fish.enable = true;

                system.configurationRevision = self.rev or self.dirtyRev or null;
                system.stateVersion = 4;

                nixpkgs.hostPlatform = system;

                users.users.${username}.home = "/Users/${username}";
              }
            )
            home-manager.darwinModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useUserPackages = true;
              home-manager.users.${username} =
                { ... }:
                {
                  nixpkgs.overlays = [ nur.overlays.default ];
                  imports = [ ./home.nix ];
                };
              home-manager.extraSpecialArgs = {
                inputs = {
                  inherit nixvim;
                };
              };
            }
          ];
          specialArgs = {
            inherit nixpkgs system;
          };
        };
    in
    {
      darwinConfigurations = {
        # Apple Silicon Mac (M3 Max)
        salarm3max = mkDarwinConfig {
          system = "aarch64-darwin";
          hostname = "salarm3max";
        };

        # Intel Mac (example - update hostname as needed)
        salarintel = mkDarwinConfig {
          system = "x86_64-darwin";
          hostname = "salarintel";
        };
      };

      darwinPackages = self.darwinConfigurations.salarm3max.pkgs;
    };
}
