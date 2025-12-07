{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    
    # This is indispensable for proper Wayland integration
    # It ensures Home Manager manages the systemd targets
    systemd.enable = true;
    
    # This reads the content of hyprland.conf and puts it into the right place
    extraConfig = builtins.readFile ./hyprland.conf;
  };

}
