{ pkgs, ... }:

{
  # Install GPG and a terminal-based pinentry
  programs.gpg = {
    enable = true;
    settings = {
      # Use a long-form key ID for better security/uniqueness
      keyid-format = "0xlong";
      with-fingerprint = true;
    };
  };

  services.gpg-agent = {
    enable = true;

    pinentryPackage = pkgs.pinentry-curses;

    # Cache the passphrase for 8 hours (28800 seconds)
    # This prevents having to re-type it for every commit
    defaultCacheTtl = 28800;
    maxCacheTtl = 28800;
    
  };
}
