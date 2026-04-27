{ config, pkgs, inputs, ... }:
{
  users.mutableUsers = false;

  users.users.nexnc = {
    isNormalUser = true;
    description = "NEXNC";
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
      "libvirtd"
      "video"
      "audio"
      "render"
    ];
    shell = pkgs.fish;
    hashedPasswordFile = config.sops.secrets.password.path;
  };

  users.users.root.hashedPasswordFile = config.sops.secrets.root_password.path;

  users.users.greeter = {
    isSystemUser = true;
    shell = pkgs.fish;
  };

  home-manager = {
    extraSpecialArgs = { 
      inherit inputs;
      systemHostname = config.networking.hostName;
    };
    backupFileExtension = "backup";
    users."nexnc" = import ../../modules/home/home.nix;
  };

  system.stateVersion = "24.11";
}
