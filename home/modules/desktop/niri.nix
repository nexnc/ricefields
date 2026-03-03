{ config, pkgs, ... }:
{
  programs.niri.settings = {
    hotkey-overlay.skip-at-startup = true;
    outputs."DP-1" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 164.998;
      };
    };

    layout = {
      gaps = 5;
      center-focused-column = "always";
      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];

      # Configure the aesthetic focus ring
      focus-ring = {
        width = 2;
        active.color = "#89b4fa";
        inactive.color = "#313244";
      };

      border.enable = false; 
    };

    # Auto-save screenshots here
    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    spawn-at-startup = [
      { command = [ "${pkgs.swww}/bin/swww-daemon" ]; }
      { command = [ "${pkgs.swww}/bin/swww" "img" "/home/nexnc/Pictures/Wallpapers/wallpaper.jpg" ]; }
      { command = [ "swaync" ]; }
      { command = [ "udiskie" "-t" ]; }
      { command = [ "wl-paste" "--watch" "cliphist" "store" ]; }
    ];

    binds = {
      # ── Launchers ────────────────────────────────────────────
      "Mod+Return".action.spawn = "foot";
      "Mod+R".action.spawn = ["wofi" "--show" "drun"];
      "Mod+B".action.spawn = "librewolf";
      "Mod+E".action.spawn = ["foot" "-e" "yazi"];
      "Mod+L".action.spawn = "hyprlock";
      "Mod+W".action.spawn = ["bash" "-c" "cliphist list | wofi --dmenu | cliphist decode | wl-copy"];
      "Mod+M".action.spawn = ["foot" "-e" "rmpc"];
      "Mod+Z".action.spawn = ["foot" "-e" "zellij" "attach" "-c" "main"];

      # ── Windows ───────────────────────────────────────────────
      "Mod+C".action.close-window = {};
      "Mod+F".action.maximize-column = {};
      "Mod+Shift+F".action.fullscreen-window = {};
      "Mod+V".action.toggle-window-floating = {};
      "Mod+Space".action.switch-focus-between-floating-and-tiling = {};
      "Mod+Shift+R".action.switch-preset-column-width = {};

      # ── Focus ─────────────────────────────────────────────────
      "Mod+Left".action.focus-column-left = {};
      "Mod+Right".action.focus-column-right = {};
      "Mod+Up".action.focus-window-up = {};
      "Mod+Down".action.focus-window-down = {};

      # ── Move ──────────────────────────────────────────────────
      "Mod+Shift+Left".action.move-column-left = {};
      "Mod+Shift+Right".action.move-column-right = {};
      "Mod+Shift+Up".action.move-window-up = {};
      "Mod+Shift+Down".action.move-window-down = {};

      # ── Resize ────────────────────────────────────────────────
      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";
      "Mod+Shift+Minus".action.set-window-height = "-10%";
      "Mod+Shift+Equal".action.set-window-height = "+10%";

      # ── Workspaces ────────────────────────────────────────────
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;
      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;
      "Mod+Shift+6".action.move-column-to-workspace = 6;
      "Mod+Shift+7".action.move-column-to-workspace = 7;
      "Mod+Shift+8".action.move-column-to-workspace = 8;
      "Mod+Shift+9".action.move-column-to-workspace = 9;
      "Mod+Tab".action.focus-workspace-previous = {};
      "Mod+Page_Up".action.focus-workspace-up = {};
      "Mod+Page_Down".action.focus-workspace-down = {};
      "Mod+Shift+Page_Up".action.move-column-to-workspace-up = {};
      "Mod+Shift+Page_Down".action.move-column-to-workspace-down = {};

      # ── Screenshots ───────────────────────────────────────────
      "Print".action.screenshot = {};
      "Mod+Print".action.screenshot-window = {};
      "Mod+Shift+Print".action.screenshot-screen = {};

      # ── Media Keys ────────────────────────────────────────────
      "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
      "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
      "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
      "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
      "XF86AudioNext".action.spawn = ["playerctl" "next"];
      "XF86AudioPrev".action.spawn = ["playerctl" "previous"];

      # ── Session ───────────────────────────────────────────────
      "Mod+Shift+Q".action.quit = {};
    };

    window-rules = [
      {
        # Global Rule: Curved corners and max width for new windows
        geometry-corner-radius = {
          top-left = 8.0;
          top-right = 8.0;
          bottom-left = 8.0;
          bottom-right = 8.0;
        };
        clip-to-geometry = true;
        open-maximized = true;
      }
      {
        matches = [{ is-floating = true; }];
      }
    ];
  };
}
