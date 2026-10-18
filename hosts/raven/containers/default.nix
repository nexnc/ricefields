{ config, pkgs, lib, ... }:

{
  virtualisation.oci-containers = {
    backend = "podman";
    containers = 
      (import ./portainer.nix) //
      (import ./cloudflared.nix { inherit config pkgs; });
  };

  # Push container startup after graphical.target so the desktop loads immediately
  systemd.services.podman-portainer = {
    after = [ "graphical.target" ];
    wantedBy = lib.mkForce [ "graphical.target" ];
  };

  systemd.services.podman-cloudflared = {
    after = [ "graphical.target" ];
    wantedBy = lib.mkForce [ "graphical.target" ];
  };
}
