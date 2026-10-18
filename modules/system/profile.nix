# modules/system/profile.nix
{ lib, config, ... }:

{
  options = {
    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "nexnc";
        description = "Primary user account name";
      };
      fullName = lib.mkOption {
        type = lib.types.str;
        default = "User";
        description = "Full name of primary user";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "git@nexnc.com";
        description = "User email for Git and GPG";
      };
    };

    profile = {
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "Europe/Berlin";
        description = "System timezone";
      };
      locale = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        description = "System locale";
      };
      desktop = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable Graphical Desktop environment";
      };
      theme = lib.mkOption { 
        type = lib.types.str; 
        default = "eldritch"; 
        description = "Global color theme for the system";
      };
    };
  };

  config = {
    time.timeZone = config.profile.timeZone;
    i18n.defaultLocale = config.profile.locale;

    i18n.extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_NAME = "en_US.UTF-8";
    };

    i18n.supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
  };
}
