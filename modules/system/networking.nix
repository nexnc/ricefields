{ ... }:
{
  networking = {
    hostName = "kerr";
     domain = "nexnc.com";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "virbr0" ];
      allowedTCPPorts = [ 56000 25565 ];
      allowedUDPPorts = [ 56000 19132 ];
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; }
      ];
      allowedUDPPortRanges = [
        { from = 1714; to = 1764; }
      ];
    };
  };

  time.timeZone = "Asia/Kolkata";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS        = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT    = "en_IN";
      LC_MONETARY       = "en_IN";
      LC_NAME           = "en_IN";
      LC_NUMERIC        = "en_IN";
      LC_PAPER          = "en_IN";
      LC_TELEPHONE      = "en_IN";
      LC_TIME           = "en_IN";
    };
  };
}
