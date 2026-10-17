{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sequoia-sq
    sequoia-chameleon-gnupg
  ];

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
    defaultCacheTtl = 28800;
    maxCacheTtl = 43200;
    # Using [A] subkeys for SSH:
    enableSshSupport = true;
    defaultCacheTtlSsh = 28800;
    maxCacheTtlSsh = 43200;
  };
}
