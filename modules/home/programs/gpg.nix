{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    settings = {
      keyid-format = "0xlong";
      with-fingerprint = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gnome3; 
    
    # 8 hours of productivity per unlock
    defaultCacheTtl = 28800;
    maxCacheTtl = 43200; # 12 hour absolute max
    defaultCacheTtlSsh = 28800;
    maxCacheTtlSsh = 43200;

    # Extra settings for reliability
    extraConfig = ''
      allow-preset-passphrase
    '';
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
  };

  home.file.".gnupg/sshcontrol".text = ''
    18A360A0734E3DAC98901A39A7563EF43D93CDF0
    A9BA550548935FEE6F80771BEB46BA24C5973E17
  '';
}
