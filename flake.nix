/*
  ╔═══════════════════════════════════════════════════════╗
  ║                                                       ║
  ║        ███████╗██╗       █████╗ ██╗  ██╗███████╗      ║
  ║        ██╔════╝██║      ██╔══██╗██║ ██╔╝██╔════╝      ║
  ║        █████╗  ██║      ███████║█████╔╝ █████╗        ║
  ║        ██╔══╝  ██║      ██╔══██║██╔═██╗ ██╔══╝        ║
  ║        ██║     ███████╗ ██║  ██║██║  ██╗███████╗      ║
  ║        ╚═╝     ╚══════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝      ║
  ║                                                       ║
  ╚═══════════════════════════════════════════════════════╝
*/
 
{
  description = "Nixos config flake"; 

  inputs = {
    # ═══════════════════════════════════════════════════════════════════════════
    #  NIXOS OFFICIAL PACKAGES
    # ═══════════════════════════════════════════════════════════════════════════
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # ═══════════════════════════════════════════════════════════════════════════
    #  HOME MANAGER
    # ═══════════════════════════════════════════════════════════════════════════
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    
    # ═══════════════════════════════════════════════════════════════════════════
    #  SYSTEM CONFIGURATION
    # ═══════════════════════════════════════════════════════════════════════════
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      
      # Target System Architecture
      system = "x86_64-linux";
      
      # Pass inputs to modules
      specialArgs = { inherit inputs; };
      
      modules = [
        # Hardware Import
        ./hardware-configuration.nix

        # Main Configuration 
        ./configuration.nix
        
        # Home Manager Module
        inputs.home-manager.nixosModules.home-manager
      ];
    };
    
    # ═══════════════════════════════════════════════════════════════════════════
    #  UTILITIES
    # ═══════════════════════════════════════════════════════════════════════════
    # Run `nix fmt` to auto-format your .nix files
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}

