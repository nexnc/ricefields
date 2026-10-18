{ config, pkgs, inputs, ... }:

let
  username = config.user.name;
  userHomeModule = if config.profile.desktop 
                   then import ../../modules/home/home.nix 
                   else import ../../modules/home/home-core.nix;
in
{
  users.mutableUsers = false;

  users.users.${username} = {
    isNormalUser = true;
    description = config.user.fullName;
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

  home-manager = {
    extraSpecialArgs = { 
      inherit inputs;
      systemHostname = config.networking.hostName;
    };
    backupFileExtension = "backup";
    users.${username} = userHomeModule;
  };

  system.stateVersion = "26.05";
}
