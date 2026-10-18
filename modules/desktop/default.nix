{ config, lib, ... }:

{
  imports = [
    ./niri.nix
    ./services.nix
    ./fonts.nix
    ./security.nix
    ./packages.nix
    ./steam.nix
    ./stylix.nix
  ];
}
