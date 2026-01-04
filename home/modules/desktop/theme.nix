{ config, pkgs, ... }:
{
  # 1. Force GTK Theme (Controls Firefox, Thunar, etc.)
  gtk = {
    enable = true;
    font.name = "Noto Sans";
    font.size = 11;
    
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        tweaks = [ "rimless" "black" ];
        variant = "mocha";
      };
    };
    
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  
  # 2. Force Qt to look like GTK (Fixes KDE Connect visual issues)
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "gtk2";
  };
  
  # 3. Add the font packages so the system finds them
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
    # ... your other packages
  ];
  
  # 4. Force GTK theme via environment variable (for stubborn apps like KiCad)
  home.sessionVariables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Mauve-Dark";
  };
}
