# █ █ █ ███  ██ ██ █ █ ███  ██ █ █ █  █  █ █ █ █ ██ ██ █ █ ██  █ ██ ██ ██  ███   █ █
# █ █ █ ███  ██ ██ █ █ ███  ██ █ █ █  █  █ █ █ █ ██ ██ █ █ ██  █ ██ ██ ██  ███   █ █
# █ █ █ ███  ██ ██ █ █ ███  ██ █ █ █  █  █ █ █ █ ██ ██ █ █ ██  █ ██ ██ ██  ███   █ █
# █ █ █ ███  ██ ██ █ █ ███  ██ █ █ █  █  █ █ █ █ ██ ██ █ █ ██  █ ██ ██ ██  ███   █ █
# █ █ █ ███  ██ ██ █ █ ███  ██ █ █ █  █  █ █ █ █ ██ ██ █ █ ██  █ ██ ██ ██  ███   █ █
# █ █ █ ███  ██ ██ █ █ ███  ██ █ █ █  █  █ █ █ █ ██ ██ █ █ ██  █ ██ ██ ██  ███   █ █
# █ █                             █ █                             █ █
# █ █                             █ █                             █ █
#          6     4     0     5     0     9         0     4     0     1     4         7
# ──────────────────────────────────────────────────────────────────────────────────
# HOME DESKTOP  //  dynamic user  //  home-manager 26.05
# user environment: gui apps, defaults, wayland session

{ config, pkgs, lib, ... }:

let
  # ▌DEFAULTS
  fileManager = "nemo.desktop";
  browser = "librewolf.desktop";
  pdfViewer = "org.kde.okular.desktop";
in
{
  # ▌IMPORTS
  imports = [
    ./home-core.nix
    ./desktop
  ];

  # ▌DEFAULT APPS
  xdg.enable = true;
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "inode/directory" = fileManager;
      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
      "application/pdf" = pdfViewer;
    };

    defaultApplicationPackages = with pkgs; [
      mpv
      loupe
      kdePackages.kate
      kdePackages.okular
    ];
  };

  # ▌UNFREE
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
    ];

  # ▌PACKAGES
  home.packages = with pkgs; [
    # ── browsers & communication
    librewolf
    thunderbird

    # ── productivity & creation
    obs-studio
    gimp

    # ── gaming
    prismlauncher
    gamescope
    protontricks
    wine-wayland
    lutris

    # ── desktop utilities
    loupe
    kdePackages.kate
    kdePackages.okular
    qbittorrent
    valent
    filen-desktop
    pavucontrol
  ];

  # ▌ENVIRONMENT
  home.sessionVariables = {
    BROWSER = "librewolf";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";

    PYTHON_KEYRING_BACKEND = "keyring.backends.libsecret.Keyring";

    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";
    DXVK_ASYNC = "1";
    RADV_PERFTEST = "gpl";
  };
}
