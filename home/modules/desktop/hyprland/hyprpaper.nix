{ config, pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      
      # PRELOAD: Load image into memory
      preload = [
        "~/Pictures/Wallpapers/wallpaper.png"
      ];

      # WALLPAPER: Apply to monitor (syntax: monitor,path)
      # empty monitor name applies to ALL monitors
      wallpaper = [
        ",~/Pictures/Wallpapers/wallpaper.png"
      ];
    };
  };
}
