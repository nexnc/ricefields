{ config, lib, pkgs, ... }:

lib.mkIf config.profile.desktop {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-color-emoji
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  console.keyMap = "us";
}
