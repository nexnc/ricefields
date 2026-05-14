{ pkgs, ... }:
let
  # This points to the wallpapers folder relative to THIS file.
  wallpapersPath = ../../../wallpapers; 

  wall-cycle = pkgs.writeShellScriptBin "wall-cycle" ''
    WALL_DIR="${wallpapersPath}"
    
    # Get a random image from the store-path directory
    NEXT_WALL=$(find "$WALL_DIR" -type f | shuf -n 1)
    
    pkill swaybg
    ${pkgs.swaybg}/bin/swaybg -m fill -i "$NEXT_WALL" &
  '';
in {
  home.packages = [ wall-cycle ];
}
