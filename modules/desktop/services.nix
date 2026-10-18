{ config, lib, pkgs, ... }:

lib.mkIf config.profile.desktop {
  services = {
    gvfs.enable = true;
    udisks2.enable = true;
    blueman.enable = true;
    tumbler.enable = true;
    printing.enable = true;
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    dbus.packages = [ pkgs.thunar ];
  };

  programs.gnome-disks.enable = true;
}
