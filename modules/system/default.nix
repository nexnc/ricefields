# modules/system/default.nix
{ ... }:

{
  imports = [
    ./boot.nix
    ./hardware-utils.nix
    ./networking.nix
    ./nix-settings.nix
    ./profile.nix
    ./sops.nix
    ./users.nix
    ./virtualization.nix
    ./fish.nix
  ];
}
