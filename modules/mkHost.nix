# modules/mkHost.nix
{ inputs }:

{
  mkHost = { hostname, system ? "x86_64-linux", theme ? "eldritch", desktop ? true, extraModules ? [] }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { 
        inherit inputs;
        currentTheme = theme;
      };
      modules = [
        ../modules/system
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        inputs.stylix.nixosModules.stylix

        # Only set host-specific infrastructural toggles here
        ({ ... }: {
          networking.hostName = hostname;
          profile.desktopEnabled = desktop;
        })
      ] ++ extraModules;
    };
}
