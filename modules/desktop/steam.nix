{ config, lib, pkgs, ... }:

lib.mkIf config.profile.desktop {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
