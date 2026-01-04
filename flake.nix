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
   
    # ═══════════════════════════════════════════════════════════════════════════
    #  SOPS-NIX
    # ═══════════════════════════════════════════════════════════════════════════
    sops-nix.url = "github:Mic92/sops-nix";

  };

  outputs = { self, nixpkgs, sops-nix, ... }@inputs: {
    
    # ═══════════════════════════════════════════════════════════════════════════
    #  SYSTEM CONFIGURATION
    # ═══════════════════════════════════════════════════════════════════════════
    nixosConfigurations = {
      
      # Desktop Configuration
      "desktop" = nixpkgs.lib.nixosSystem {
	# Target System Architecture
	system = "x86_64-linux";
	# Pass inputs to modules
	specialArgs = { inherit inputs; };
	modules = [
          # Hardware Import
          ./hosts/desktop/hardware-configuration.nix
          # Main Configuration 
          ./hosts/desktop/configuration.nix
	  # Podman Containers
	  ./hosts/desktop/containers
          # Home Manager Module
          inputs.home-manager.nixosModules.home-manager
	  # Sops-nix Module
	  inputs.sops-nix.nixosModules.sops
        ];
      };

      # VM Configuration
      "vm" = nixpkgs.lib.nixosSystem {
	# Target System Architecture
	system = "x86_64-linux";
	specialArgs = {inherit inputs;};
	modules = [
	  # Main Configuration
	  ./hosts/vm/configuration.nix
	  # Home Manager Module
	  inputs.home-manager.nixosModules.home-manager
	  # Sops-nix module
	  inputs.sops-nix.nixosModules.sops
	];
      };
   };

   # ═══════════════════════════════════════════════════════════════════════════
    #  TEMPLATES
    # ═══════════════════════════════════════════════════════════════════════════
    # Usage: nix flake init -t /etc/nixos#universal
    templates = {
      universal = {
        path = ./templates/universal;
        description = "Universal devShell";
      };
    };
    
    # ═══════════════════════════════════════════════════════════════════════════
    #  UTILITIES
    # ═══════════════════════════════════════════════════════════════════════════
    # Run `nix fmt` to auto-format your .nix files
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}

