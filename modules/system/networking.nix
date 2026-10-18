{ ... }:
{
  networking = {
    networkmanager.enable = true;


    nameservers = [
      "1.0.0.1"
      "8.8.8.8"
    ];

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

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
