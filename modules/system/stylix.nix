{ pkgs, currentTheme, ... }: 

let
  themes = {
    mocha = {
      scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      wallpaper = /home/nexnc/Pictures/Wallpapers/mocha.jpg;
    };
    nord = {
      scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
      wallpaper = /home/nexnc/Pictures/Wallpapers/nordic.jpg;
    };
  };
  
  # Grab the set from the list, or default to mocha if something goes wrong
  selected = themes."${currentTheme}" or themes.mocha;

in {
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

    fonts.monospace = {
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      name = "JetBrainsMono Nerd Font";
    };
  };
}
