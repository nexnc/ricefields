{ config, pkgs, ... }:

{
programs.foot = {
  enable = true;
  
  settings = {
    main = {
      term = "foot";
      font = "JetBrainsMonoNL Nerd Font:size=14";
      # Foot uses a single font declaration, variants are auto-detected
      dpi-aware = "yes";
    };
    
    mouse = {
      hide-when-typing = "yes";
    };
    
    # Import Catppuccin Mocha theme
    # You'll need to add the colors manually or use a foot theme
    colors = {
      # Catppuccin Mocha colors
      alpha = "1.0";
      foreground = "cdd6f4";
      background = "1e1e2e";
      
      # Regular colors
      regular0 = "45475a";  # Surface1
      regular1 = "f38ba8";  # Red
      regular2 = "a6e3a1";  # Green
      regular3 = "f9e2af";  # Yellow
      regular4 = "89b4fa";  # Blue
      regular5 = "f5c2e7";  # Pink
      regular6 = "94e2d5";  # Teal
      regular7 = "bac2de";  # Subtext1
      
      # Bright colors
      bright0 = "585b70";   # Surface2
      bright1 = "f38ba8";   # Red
      bright2 = "a6e3a1";   # Green
      bright3 = "f9e2af";   # Yellow
      bright4 = "89b4fa";   # Blue
      bright5 = "f5c2e7";   # Pink
      bright6 = "94e2d5";   # Teal
      bright7 = "a6adc8";   # Subtext0
    };
   };
  };
}

