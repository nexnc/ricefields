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

    # 
    # NIRI
    #
    niri.url = "github:sodiboo/niri-flake";

  };

  outputs = { self, nixpkgs, sops-nix, ... }@inputs: {
    
    # ═══════════════════════════════════════════════════════════════════════════
    #  SYSTEM CONFIGURATION
    # ═══════════════════════════════════════════════════════════════════════════
    nixosConfigurations = {

      "kerr" = nixpkgs.lib.nixosSystem {
    	system = "x86_64-linux";
    	specialArgs = { inherit inputs; };
   	modules = [
      	  ./hosts/kerr/default.nix
      	  inputs.home-manager.nixosModules.home-manager
      	  inputs.sops-nix.nixosModules.sops
      	  inputs.niri.nixosModules.niri
    	];
     };

     "vm" = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       specialArgs = { inherit inputs; };
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

