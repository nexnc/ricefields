{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    style = ''
      @define-color base     #1e1e2e;
      @define-color mantle   #181825;
      @define-color crust    #11111b;
      @define-color text     #cdd6f4;
      @define-color surface0 #313244;
      @define-color mauve    #cba6f7;
      @define-color red      #f38ba8;
      @define-color green    #a6e3a1;

      * {
        /* Added fallbacks to ensure all icons render properly */
        font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font", sans-serif;
        font-size: 13px;
      }

      window#waybar {
        background-color: @base;
        border-bottom: 2px solid @surface0;
        color: @text;
      }

      /* Niri Workspace Styling */
      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: @text;
        border-bottom: 3px solid transparent;
      }

      /* Fixed to use .active for Niri workspaces */
      #workspaces button.active {
        color: @mauve;
        border-bottom: 3px solid @mauve;
      }

      #workspaces button.urgent {
        background-color: @red;
        color: @base;
      }

      #clock, #battery, #cpu, #memory, #disk, #network, #pulseaudio, #tray, #custom-power {
        padding: 0 10px;
        color: @text;
        border-radius: 10px;
        margin: 5px 2px;
        background-color: @surface0;
      }

      #clock { background-color: @mauve; color: @base; }
      #custom-power { color: @red; font-size: 15px; }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        
        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "disk" "battery" "tray" "custom-power" ];

        "niri/workspaces" = {
          format = "{index}";
          };

        "niri/window" = {
          format = "{}";
          separate-outputs = true;
        };

        # --- QoL Additions ---
        "disk" = {
          interval = 30;
          format = "{percentage_used}% 󰋊";
          path = "/";
        };

        "custom-power" = {
          format = "⏻";
          on-click = "wlogout"; # Make sure wlogout is in your home.packages
          tooltip = false;
        };

        # --- Existing Modules ---
        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        "cpu" = { format = "{usage}% "; tooltip = false; };
        "memory" = { format = "{}% "; };

        "battery" = {
          states = { warning = 30; critical = 15; };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-icons = ["" "" "" "" ""];
        };

        # --- Fixed Network Module ---
        "network" = {
          format = "{ifname}";
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "Connected 󰈀";
          format-disconnected = "Disconnected ⚠";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ipaddr}/{cidr} 󰈀";
          tooltip-format-disconnected = "Disconnected";
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-muted = "Muted 󰝟";
          format-icons = { default = ["" "" ""]; };
          on-click = "pavucontrol";
        };
      };
    };
  };
}
