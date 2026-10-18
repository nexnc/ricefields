# hosts/comet/comet.nix
{ inputs, ... }:

{
  flake.nixosConfigurations.comet = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { 
      inherit inputs; 
      currentTheme = "rose-pine"; 
    };
    
    modules = [
      ./hardware-configuration.nix
      ../../modules/system
      ../../modules/desktop

      ({ ... }: {
        networking.hostName = "comet";
        profile.desktop = true;
      })

      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.stylix.nixosModules.stylix
      inputs.niri.nixosModules.niri
    ];
  };
}
