{ config, lib, pkgs, ... }: 

let
  currentTheme = config.profile.theme;

  themes = {
    rose-pine = {
      scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      wallpaper = ../../wallpapers/nix.jpg;
    };
    eldritch = {
      scheme = "${pkgs.base16-schemes}/share/themes/eldritch.yaml";
      wallpaper = ../../wallpapers/nix.jpg;
    };
    mellow-purple = {
      scheme = "${pkgs.base16-schemes}/share/themes/mellow-purple.yaml";
      wallpaper = ../../wallpapers/nix.jpg;
    };
    catppuccin-mocha = {
      scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      wallpaper = ../../wallpapers/nix.jpg;
    };
  };
  
  selected = themes."${currentTheme}" or themes.catppuccin-mocha;

in
lib.mkIf config.profile.desktop {
  stylix = {
    enable = true;
    image = selected.wallpaper;
    base16Scheme = selected.scheme;
    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus";
    };

    fonts = {
      monospace = { package = pkgs.nerd-fonts.jetbrains-mono; name = "JetBrainsMono Nerd Font"; };
      sansSerif = { package = pkgs.dejavu_fonts; name = "DejaVu Sans"; };
      serif = { package = pkgs.dejavu_fonts; name = "DejaVu Serif"; };
      emoji = { package = pkgs.noto-fonts-color-emoji; name = "Noto Color Emoji"; };
      sizes = { applications = 11; terminal = 14; desktop = 11; popups = 11; };
    };
  };
}
