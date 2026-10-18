{ config, lib, ... }:

lib.mkIf config.profile.desktop {
  security = {
    polkit.enable = true;
    sudo.wheelNeedsPassword = true;
    pam.services.greetd.enableGnomeKeyring = true;
  };
}
