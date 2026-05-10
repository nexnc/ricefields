{ pkgs, currentTheme, ... }: 

let
  themes = {
    mocha = {
      scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      wallpaper = ../../wallpapers/nix.jpg;
    };
    synth-midnight-dark = {
      scheme = "${pkgs.base16-schemes}/share/themes/synth-midnight-dark.yaml";
      wallpaper = ../../wallpapers/nix.jpg;
    };
  };
  
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
