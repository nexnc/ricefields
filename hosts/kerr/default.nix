{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
    ./containers
    ./LocalAI
    ../../modules/system
  ];

  networking.hostName = "kerr";
  networking.domain = "nexnc.com";
}
