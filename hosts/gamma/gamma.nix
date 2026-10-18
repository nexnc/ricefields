# hosts/gamma/gamma.nix
{ inputs, ... }:

{
  flake.nixosConfigurations.gamma = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { 
      inherit inputs; 
    };
    
    modules = [
      ./hardware-configuration.nix
      ../../modules/system

      ({ ... }: {
        networking.hostName = "gamma";
        profile.desktop = false; # Disables GUI/Niri/Waybar components
      })

      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
    ];
  };
}
