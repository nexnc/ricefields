{ config, pkgs, inputs, ... }:

{
  # We keep the import for the package/service, but we write the config manually
  imports = [ inputs.niri.homeModules.niri ];

  programs.niri.enable = true;

  xdg.configFile."niri/config.kdl".text = ''
    // --- Monitor Configuration ---
    output "DP-1" {
        mode "1920x1080@165"
    }

    // --- Layout & Aesthetics ---
    layout {
        gaps 5
        center-focused-column "never"
        
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        focus-ring {
            width 2
            active-color "#33ccffee"
            inactive-color "#595959aa"
        }
    }

    // --- Autostart ---
    spawn-at-startup "${pkgs.swww}/bin/swww-daemon"
    spawn-at-startup "waybar"
    spawn-at-startup "swaync"
    spawn-at-startup "udiskie" "-t"

    // --- Keybindings ---
    binds {
        Mod+Return { spawn "foot"; }
        Mod+C { close-window; }
        Mod+Q { quit; }
        Mod+R { spawn "wofi" "--show" "drun"; }
        Mod+L { spawn "hyprlock"; }
        Mod+B { spawn "librewolf"; }
        Mod+E { spawn "foot" "-e" "yazi"; }

        // Navigation
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        
        Mod+Up    { focus-window-or-workspace-up; }
        Mod+Down  { focus-window-or-workspace-down; }

        // Resizing
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        // Workspaces
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
    }

    window-rule {
        match is-floating=true
        block-out-of-bounds false
    }
  '';
}
