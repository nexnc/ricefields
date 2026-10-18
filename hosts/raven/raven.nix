# hosts/raven/raven.nix
{ inputs, ... }:

{
  flake.nixosConfigurations.raven = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { 
      inherit inputs; 
      currentTheme = "eldritch"; 
    };

    modules = [
      ./hardware.nix
      ./hardware-configuration.nix
      ./containers
      ./LocalAI
      ../../modules/system
      ../../modules/desktop

      ({ ... }: {
        networking.hostName = "raven";
      })

      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.stylix.nixosModules.stylix
      inputs.niri.nixosModules.niri
    ];
  };
}
