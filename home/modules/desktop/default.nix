{ pkgs, ... }:

{

  imports = [
    # --- Compositor & Wallpaper ---
    ./niri.nix
    ./swww.nix

    # --- Shared Wayland Tools ---
    ./waybar.nix
    ./wofi.nix
    ./swaync.nix
    ./theme.nix
    ./wlogout.nix
    ./hyprlock.nix
  ];
}
