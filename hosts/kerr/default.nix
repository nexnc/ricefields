{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
    ./containers
    ../../modules/system
  ];
}
