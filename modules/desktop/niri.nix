{ config, lib, pkgs, ... }:

lib.mkIf config.profile.desktop {
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

  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
    shell = pkgs.fish;
  };

  users.groups.greeter = {};

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "gtk" ];
      niri = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Access" = [ "gtk" ];
        "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
      };
    };
  };
}
