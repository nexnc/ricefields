# █ █ █ ███  ██ ██ █ █ ███  ██ █ █ █  █  █ █ █ █ ██ ██ █ █ ██  █ ██ ██ ██  ███   █ █
# █ █ █ ███  ██ ██ █ █ ███  ██ █ █ █  █  █ █ █ █ ██ ██ █ █ ██  █ ██ ██ ██  ███   █ █
# █ █ █ ███  ██ ██ █ █ ███  ██ █ █ █  █  █ █ █ █ ██ ██ █ █ ██  █ ██ ██ ██  ███   █ █
# █ █ █ ███  ██ ██ █ █ ███  ██ █ █ █  █  █ █ █ █ ██ ██ █ █ ██  █ ██ ██ ██  ███   █ █
# █ █ █ ███  ██ ██ █ █ ███  ██ █ █ █  █  █ █ █ █ ██ ██ █ █ ██  █ ██ ██ ██  ███   █ █
# █ █ █ ███  ██ ██ █ █ ███  ██ █ █ █  █  █ █ █ █ ██ ██ █ █ ██  █ ██ ██ ██  ███   █ █
# █ █                                    █ █                                     █ █
# █ █                                    █ █                                     █ █
#        6     4    0     5     0    9        0    4    0    1     4       7
# ──────────────────────────────────────────────────────────────────────────────────
# HOME  //  nexnc  //  home-manager 26.05
# nexnc.com  ·  user environment: defaults, packages, session

{ config, pkgs, lib, ... }:

let
  # ▌DEFAULTS
  fileManager = "thunar.desktop"; # installed system-wide via programs.thunar
  browser = "librewolf.desktop";
in
{
  # ▌CORE
  home.username = "nexnc";
  home.homeDirectory = "/home/nexnc";
  home.stateVersion = "26.05";

  # ▌IMPORTS
  imports = [
    ./desktop
    ./programs
    ./services
    ./scripts
  ];

  # ▌DEFAULT APPS
  xdg.mimeApps = {
    enable = true;

    # explicit picks
    defaultApplications = {
      "inode/directory" = fileManager;
      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
    };

    # everything these apps can open becomes theirs (order = priority)
    defaultApplicationPackages = with pkgs; [
      mpv # video + music
      gthumb # images
      gnome-text-editor # text files
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
    librewolf                    # privacy-hardened Firefox fork
    thunderbird                  # email, calendar & RSS client

    # ── productivity & creation
    obs-studio                   # screen recording & live streaming
    gimp                         # full-featured raster image editor

    # ── gaming
    prismlauncher                # Minecraft launcher with multiple instances
    gamescope                    # Valve's game compositor: scaling, FSR, frame limits
    protontricks                 # winetricks for Proton / Steam games
    wine-wayland                 # Wine with native Wayland support
    lutris                       # game launcher for Wine, emulators & native games

    # ── development
    python3                      # Python interpreter
    rustup                       # Rust toolchain manager
    gcc                          # GNU C/C++ compiler
    uv                           # extremely fast Python package & project manager
    pixi                         # project-based, conda-compatible package manager

    # ── desktop utilities
    gnome-text-editor            # simple, fast GUI text editor
    fastfetch                    # fast system info display
    ffmpeg                       # audio/video converter & swiss-army knife
    yt-dlp                       # download video/audio from YouTube & 1000+ sites
    aria2                        # multi-connection download utility
    p7zip                        # 7z archiver
    exiftool                     # read/write image & file metadata
    gthumb                       # image viewer & browser with basic editing (crop, rotate, resize, colors)
    qbittorrent                  # BitTorrent client
    valent                       # KDE Connect-compatible phone sync for GNOME
    filen-desktop                # Filen end-to-end encrypted cloud sync
    filen-cli                    # Filen cloud storage from the terminal
    wireguard-tools              # WireGuard VPN CLI (wg, wg-quick)
    glow                         # render Markdown in the terminal
    figlet                       # big ASCII-art text banners
    lolcat                       # rainbow-colored terminal output
    whois                        # domain / IP registration lookup
    universal-android-debloater  # remove bloatware from Android phones
    android-tools                # adb & fastboot
    pavucontrol                  # PipeWire / PulseAudio volume control GUI
    bluetui                      # terminal UI for Bluetooth
    usbutils                     # lsusb: list USB devices
    pciutils                     # lspci: list PCI devices
    ncdu                         # interactive disk usage browser
    rclone                       # syncing client

    # ── terminal tools
    wl-clipboard                 # wl-copy / wl-paste for the Wayland clipboard
    cliphist                     # clipboard history for Wayland
    eza                          # modern ls
    ripgrep                      # fast recursive grep
    fd                           # fast, friendly find
    bat                          # cat with syntax highlighting
    dust                         # du, but visual and intuitive
    duf                          # df, but readable: disks at a glance
    gdu                          # fast disk usage analyzer (TUI)
    tldr                         # simplified, example-based man pages
    delta                        # syntax-highlighting pager for git diffs
    tokei                        # count lines of code per language
    btop                         # resource monitor: CPU, RAM, disks, network
    bandwhich                    # network bandwidth usage per process
    just                         # command runner (make, for tasks)
    hyperfine                    # command-line benchmarking
    pastebinit                   # paste text to dpaste.com from the terminal

    # ── security
    gpg-tui                      # terminal UI for GPG keys
    gcr                          # GNOME keyring prompts & certificate viewers
  ];

  # ▌ENVIRONMENT
  # exports XDG_{CACHE,CONFIG,DATA,STATE}_HOME at the default paths
  xdg.enable = true;

  home.sessionVariables = {
    # defaults
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
    TERMINAL = "foot";
    BROWSER = "librewolf";

    # wayland
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "niri:GNOME";
    XDG_SESSION_TYPE = "wayland";

    # keyring
    PYTHON_KEYRING_BACKEND = "keyring.backends.libsecret.Keyring";

    # game driver fixes: correct 32/64-bit vulkan drivers + background shader compilation
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";
    DXVK_ASYNC = "1";
    RADV_PERFTEST = "gpl"; # fixes movement jitters
  };

  # ▌HOME-MANAGER
  programs.home-manager.enable = true;
}
