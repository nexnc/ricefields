{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    settings = {
      keyid-format = "0xlong";
      with-fingerprint = true;
      use-agent = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-curses;
    defaultCacheTtl = 28800;
    maxCacheTtl = 28800;
    defaultCacheTtlSsh = 28800;
    maxCacheTtlSsh = 28800;
  };

  home.file.".gnupg/sshcontrol".text = ''
    18A360A0734E3DAC98901A39A7563EF43D93CDF0
    A9BA550548935FEE6F80771BEB46BA24C5973E17
  '';
}
