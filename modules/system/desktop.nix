{ pkgs, lib, inputs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --cmd niri-session";
      user = "greeter";
    };
  };

  services.dbus.packages = [ pkgs.nautilus ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome  # screencasting
      xdg-desktop-portal-gtk
      gnome-keyring
    ];
    config = {
      common.default = [ "gtk" ];
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.Access" = [ "gtk" ];
        "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
      };
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  console.keyMap = "us";
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-color-emoji
  ];
  programs.gnome-disks.enable = true;
  services = {
    gvfs.enable    = true;
    udisks2.enable = true;
    blueman.enable = true;
    tumbler.enable = true;
    printing.enable = true;
    flatpak.enable = true;
    gnome.gnome-keyring.enable = lib.mkForce false;
  };
  security = {
    polkit.enable = true;
    sudo.wheelNeedsPassword = true;
   # pam.services.greetd.enableGnomeKeyring = true;
  };
  environment.profileRelativeEnvVars.XDG_DATA_DIRS = [ "share" ];
  environment.sessionVariables = {
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/glib-2.0/schemas";
  };
  environment.systemPackages = with pkgs; [
    wget
    curl
    nautilus
    gparted
    udiskie
    polkit_gnome
    ddcutil
    podman-tui
    podman-compose
    slirp4netns
    fuse-overlayfs
    libsecret
    sops
    age
    gamemode
    amdgpu_top
    mangohud
    xwayland-satellite
    slurp                     # Required by xdg-desktop-portal-wlr for region selection
  ];
  programs.fish.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  system.autoUpgrade = {
    enable = false;
    allowReboot = false;
  };
}
