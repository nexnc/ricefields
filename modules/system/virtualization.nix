{ pkgs, lib, ... }:
{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  systemd.services.libvirtd = {
    after = [ "graphical.target" ];
    wantedBy = lib.mkForce [ "graphical.target" ];
  };
  systemd.services.libvirt-guests = {
    after = [ "graphical.target" ];
    wantedBy = lib.mkForce [ "graphical.target" ];
  };

  programs.virt-manager.enable = true;
}
