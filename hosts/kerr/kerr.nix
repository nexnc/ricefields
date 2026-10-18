# hosts/kerr/kerr.nix
{ inputs, ... }:

{
  flake.nixosConfigurations.kerr = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { 
      inherit inputs; 
      currentTheme = "eldritch"; 
    };
    
    modules = [
      ./hardware-configuration.nix
      ../../modules/system
      ../../modules/desktop

      ({ ... }: {
        networking.hostName = "kerr";
      })

      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.stylix.nixosModules.stylix
      inputs.niri.nixosModules.niri
    ];
  };
}
