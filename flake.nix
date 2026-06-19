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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # ═══════════════════════════════════════════════════════════════════════════
    #  HOME MANAGER
    # ═══════════════════════════════════════════════════════════════════════════
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   
    # ═══════════════════════════════════════════════════════════════════════════
    #  SOPS-NIX
    # ═══════════════════════════════════════════════════════════════════════════
    sops-nix.url = "github:Mic92/sops-nix";

    # ═══════════════════════════════════════════════════════════════════════════
    #  NIRI
    # ═══════════════════════════════════════════════════════════════════════════
    niri.url = "github:sodiboo/niri-flake";

    # ═══════════════════════════════════════════════════════════════════════════
    #  STYLIX
    # ═══════════════════════════════════════════════════════════════════════════
    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, sops-nix, stylix, ... }@inputs: {
    
    # ═══════════════════════════════════════════════════════════════════════════
    #  SYSTEM CONFIGURATION
    # ═══════════════════════════════════════════════════════════════════════════
    nixosConfigurations = {

      "kerr" = nixpkgs.lib.nixosSystem {
    	system = "x86_64-linux";
    	specialArgs = { inherit inputs; currentTheme = "synth-midnight-dark";};
   	modules = [
      	  ./hosts/kerr/default.nix
      	  inputs.home-manager.nixosModules.home-manager
      	  inputs.sops-nix.nixosModules.sops
      	  inputs.niri.nixosModules.niri
	  inputs.stylix.nixosModules.stylix
    	];
     };

     "vm" = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       specialArgs = { inherit inputs; currentTheme = "nord";};
       modules = [
        ./hosts/vm/default.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
      ];
    };  
   };

    # ═══════════════════════════════════════════════════════════════════════════
    #  UTILITIES
    # ═══════════════════════════════════════════════════════════════════════════
    # Run `nix fmt` to auto-format your .nix files
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}

