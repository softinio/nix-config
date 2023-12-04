{
  description = "Nix and home-manager configurations for Softinio's macbook";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = github:nix-community/nur;
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = {self, nix-darwin, home-manager, nur, nixpkgs, ...}:
    let
      homeManagerConfFor = config: { ... }: {
        nixpkgs.overlays = [ nur.overlay ];
        imports = [ config ];
      };
    
      m3maxConfiguration = { pkgs, ... }: {
        environment.systemPackages = with pkgs;
        [
          home-manager
        ];
      
      fonts = {
        fontDir.enable = true;
        fonts = with pkgs; [
          fira-code
        ];
      };
      
      services.nix-daemon.enable = true;
      
      nix = {
        nixPath = nixpkgs.lib.mkForce [
          "nixpkgs=${nixpkgs}"
        ];
        
        package = pkgs.nixUnstable;
        settings = {
          experimental-features = "nix-command flakes repl-flake";
          extra-platforms = [ "x86_64-darwin" "aarch64-darwin" ];
          trusted-users = [ "root" "salar" ];
        };
        distributedBuilds = false;
      };
      
      programs.fish.enable = true;
      
      system.configurationRevision = self.rev or self.dirtyRev or null;
      
      system.stateVersion = 4;
      
      nixpkgs.hostPlatform = "aarch64-darwin";
      
      users = {
        users.salar = {
          home = /Users/salar;
        };
      };
    };
  in
  {
    darwinConfigurations.salarm3max = nix-darwin.lib.darwinSystem {
      system = "aarc64-darwin";
      modules = [
        m3maxConfiguration
        home-manager.darwinModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.users.salar = homeManagerConfFor ./home.nix;
        }
      ];
      specialArgs = { inherit nixpkgs; };
    };
    
    darwinPackages = self.darwinConfigurations.salarm3max.pkgs;
    
    defaultPackage.aarch64-darwin = self.darwinConfigurations.salarm3max.system;
  };
}
