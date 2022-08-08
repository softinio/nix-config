{
  description = "Nix and home-manager configurations for Softinio's macbook";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = github:nix-community/nur;
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {darwin, home-manager, nur, nixpkgs, ...}:
    let
      homeManagerConfFor = config: { ... }: {
        nixpkgs.overlays = [ nur.overlay ];
        imports = [ config ];
      };
      darwinSystem = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager {
            home-manager.users.salar = homeManagerConfFor ./home.nix;
          }
        ];
        specialArgs = { inherit nixpkgs; };
      };
    in {
      defaultPackage.x86_64-darwin = darwinSystem.system;
    };
}
