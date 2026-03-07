{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    ironbar
    adwaita-icon-theme
  ];

  systemd.user.services.ironbar = {
    Unit = {
      Description = "Ironbar";
      After = [ "graphical-session.target" "dbus.service" ];
      Wants = [ "dbus.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStartPre = "/bin/sh -c 'until [ -S \"$XDG_RUNTIME_DIR/niri/socket\" ]; do sleep 0.2; done'";
      ExecStart = "${pkgs.ironbar}/bin/ironbar";
      Restart = "on-failure";
      RestartSec = "1s";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  xdg.configFile."ironbar/config.json".text = builtins.toJSON {
    position = "top";
    height = 36;
    margin = {
      top = 6;
      left = 6;
      right = 6;
      bottom = 0;
    };
    icon_theme = "Papirus-Dark";

    start = [
      { type = "workspaces"; }
      { type = "focused"; show_icon = false; show_title = true; }
    ];

    center = [
      {
        type = "clock";
        format = "%H:%M  %a %d %b";
      }
    ];

    end = [
      {
        type = "volume";
        format = "{icon} {percentage}%";
        on_scroll_up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        on_scroll_down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        on_click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        icons = {
          volume_high = "󰕾";
          volume_medium = "󰖀";
          volume_low = "󰕿";
          muted = "󰝟";
        };
      }
      {
        type = "network_manager";
      }
      {
        type = "sys_info";
        interval = { cpu = 5; memory = 5; disks = 30; };
        format = [
          "󰻠 {cpu_percent}%"
          "󰍛 {memory_percent}%"
          "󰋊 {disk_percent@/}%"
        ];
      }
      {
        type = "tray";
        icon_size = 16;
      }
    ];
  };

  xdg.configFile."ironbar/style.css".text = ''
    @define-color base      #1e1e2e;
    @define-color mantle    #181825;
    @define-color crust     #11111b;
    @define-color text      #cdd6f4;
    @define-color surface0  #313244;
    @define-color surface1  #45475a;
    @define-color surface2  #585b70;
    @define-color mauve     #cba6f7;
    @define-color red       #f38ba8;
    @define-color green     #a6e3a1;
    @define-color blue      #89b4fa;

    * {
      font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font", sans-serif;
      font-size: 13px;
      border: none;
      border-radius: 0;
      box-shadow: none;
      text-shadow: none;
    }

    button {
      background: transparent;
      padding: 0;
      color: inherit;
      min-height: 0;
      min-width: 0;
    }

    button:hover {
      background: transparent;
      box-shadow: none;
    }

    window, window#ironbar {
      background-color: transparent;
    }

    #bar {
      background-color: transparent;
    }

    /* --- Floating Pills --- */

    .start, .center, .end {
      border-radius: 24px;
      margin-top: 2px;
      margin-bottom: 2px;
    }

    .start {
      background-color: alpha(@base, 0.85);
      padding: 0 4px;
    }

    .center {
      background-color: @crust;
      padding: 0 20px;
    }

    .end {
      background-color: alpha(@base, 0.85);
      padding: 0 8px;
    }

    /* --- Workspaces --- */

    .workspaces {
      margin: 0;
    }

    .workspaces .item {
      padding: 4px 14px;
      color: alpha(@text, 0.45);
      border-radius: 24px;
      margin: 4px 2px;
      transition: all 150ms ease;
    }

    .workspaces .item:hover {
      color: @text;
      background-color: alpha(@surface0, 0.6);
    }

    .workspaces .item.focused {
      background-color: @mauve;
      color: @crust;
      font-weight: bold;
    }

    .workspaces .item.urgent {
      background-color: @red;
      color: @crust;
    }

    /* --- Focused Window Title --- */

    .focused {
      padding: 0 12px 0 8px;
      color: alpha(@text, 0.7);
    }

    /* --- Clock --- */

    .clock {
      color: @text;
      padding: 6px 0;
      font-weight: bold;
    }

    /* --- Right pill modules --- */

    .volume,
    .network_manager,
    .sys_info,
    .tray {
      padding: 0 10px;
      color: @text;
    }

    .volume,
    .network_manager,
    .sys_info {
      border-right: 1px solid alpha(@surface1, 0.5);
    }

    /* icon + label spacing inside each module */
    .volume label,
    .network_manager label {
      margin-left: 4px;
    }

    .sys_info label {
      padding: 0 5px;
    }

    .tray {
      margin-top: 6px;
      margin-bottom: 6px;
    }

    /* --- Network Manager popup --- */

    .network-manager-popup,
    popover,
    popover > contents,
    popover contents box {
      background-color: @mantle;
      color: @text;
      border-radius: 12px;
      border: 1px solid alpha(@surface1, 0.6);
      padding: 8px;
    }

    popover label {
      color: @text;
    }

    popover entry {
      background-color: @surface0;
      color: @text;
      border-radius: 6px;
      border: 1px solid @surface1;
      padding: 4px 8px;
    }

    popover button {
      background-color: @surface0;
      color: @text;
      border-radius: 6px;
      padding: 4px 10px;
      margin: 2px;
    }

    popover button:hover {
      background-color: @surface1;
    }

    /* --- Volume popup (if shown) --- */

    .volume-popup,
    .popup {
      background-color: @mantle;
      color: @text;
      border-radius: 12px;
      border: 1px solid alpha(@surface1, 0.6);
      padding: 12px;
    }

    .popup label,
    .popup scale {
      color: @text;
    }

    .popup scale trough {
      background-color: @surface0;
      border-radius: 6px;
    }

    .popup scale highlight {
      background-color: @mauve;
      border-radius: 6px;
    }
  '';
}
