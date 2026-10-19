{ config, lib, pkgs, ... }:

lib.mkIf config.profile.desktop {
  environment.profileRelativeEnvVars.XDG_DATA_DIRS = [ "share" ];
  
  environment.sessionVariables = {
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/glib-2.0/schemas";
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    nemo
    gparted
    udiskie
    polkit_gnome
    ddcutil
    podman-tui
    podman-compose
    slirp4netns
    fuse-overlayfs
    libsecret
    age
    amdgpu_top
    xwayland-satellite
    slurp
  ];
}
