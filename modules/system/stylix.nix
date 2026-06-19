{ pkgs, currentTheme, ... }: 

let
  themes = {
    rose-pine = {
      scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      wallpaper = ../../wallpapers/nix.jpg;
    };
  };
  
  selected = themes."${currentTheme}" or themes.rose-pine;

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

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      # Added Emoji support
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 11;
        terminal = 14;
        desktop = 11;
        popups = 11;
      };
    };
  };
}
