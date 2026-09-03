{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
    ./containers
    ./LLM/ollama.nix
    ../../modules/system
  ];

  networking.hostName = "kerr";
  networking.domain = "nexnc.com";
}
