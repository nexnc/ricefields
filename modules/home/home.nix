/*
  ╔═══════════════════════════════════════════════════════╗
  ║                                                       ║
  ║        ██╗  ██╗ ██████╗ ███╗   ███╗███████╗           ║
  ║        ██║  ██║██╔═══██╗████╗ ████║██╔════╝           ║
  ║        ███████║██║   ██║██╔████╔██║█████╗             ║
  ║        ██╔══██║██║   ██║██║╚██╔╝██║██╔══╝             ║
  ║        ██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗           ║
  ║        ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝           ║
  ║                                                       ║
  ╚═══════════════════════════════════════════════════════╝
*/

{ config, pkgs, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  #  CORE CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  home.username      = "nexnc";
  home.homeDirectory = "/home/nexnc";
  home.stateVersion  = "25.11"; # Updated to match system version

  # ═══════════════════════════════════════════════════════════════════════════
  #  MODULE IMPORTS
  # ═══════════════════════════════════════════════════════════════════════════
  imports = [
    # Desktop Environment
    ./desktop

    # User Programs
    ./programs
 
    # User Services
    ./services
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  #  ALLOW UNFREE PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [
        "davinci-resolve"
	"steam-unwrapped"
	"steam"
      ];

  # ═══════════════════════════════════════════════════════════════════════════
  #  USER PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # ─── Browsers & Communication ──────────────────────────────────────────────
    librewolf
    thunderbird
    signal-desktop
    fractal

    # ─── Media & Entertainment ─────────────────────────────────────────────────

    # ─── Productivity & Creation ───────────────────────────────────────────────
    obs-studio
    gimp
    # davinci-resolve
    kicad
    godot


    # ─── Gaming ────────────────────────────────────────────────────────────────
    prismlauncher
    gamescope
    protontricks
    wine-wayland
    steam
    lutris

    # ─── Development ───────────────────────────────────────────────────────────
    python3
    rustup
    gcc
    uv
    pixi

    # ─── Desktop Utilities ─────────────────────────────────────────────────────
    fastfetch
    yt-dlp
    aria2
    p7zip
    exiftool
    nsxiv
    qbittorrent
    valent
    filen-desktop
    filen-cli
    wireguard-tools
    glow 	    # Markdown Reader in Terminal
    figlet
    lolcat
    whois
    universal-android-debloater
    android-tools
    pavucontrol
    bluetui
    usbutils
    pciutils

    # ─── Terminal Tools ────────────────────────────────────────────────────────
    wl-clipboard
    cliphist
    eza             # Better ls
    ripgrep         # Better grep
    fd              # Better find
    bat             # Better cat
    dust            # Disk usage
    duf             # Disk usage (TUI)
    gdu             # Disk usage analyzer
    tldr            # Simplified man pages
    delta           # Better git diff
    tokei           # Count lines of code
    btop            # Process manager
    bandwhich       # Network monitor
    just            # Command runner
    hyperfine       # Benchmarking
    pastebinit      # Copying text to dpaste.com

    # ----- Security -----------------------------------------------------------
    gpg-tui
    gcr

  ];

  # ═══════════════════════════════════════════════════════════════════════════
  #  ENVIRONMENT VARIABLES
  # ═══════════════════════════════════════════════════════════════════════════
  home.sessionVariables = {
    # Core defaults
    EDITOR   = "nvim";
    VISUAL   = "nvim";
    TERMINAL = "foot";
    BROWSER  = "librewolf";

    # XDG Directories
    XDG_CACHE_HOME  = "${config.home.homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME   = "${config.home.homeDirectory}/.local/share";

    # Wayland Compatibility
    MOZ_ENABLE_WAYLAND  = "1";
    XDG_CURRENT_DESKTOP = "niri:GNOME";
    XDG_SESSION_TYPE    = "wayland";

    # Keyring
    PYTHON_KEYRING_BACKEND = "keyring.backends.libsecret.Keyring";

    # Game Driver Fixes
    # Forces correct 32-bit/64-bit drivers and enables background shader compilation
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";
    DXVK_ASYNC = "1";
    RADV_PERFTEST = "gpl"; # Performance fix for movement jitters
  };

  # ═══════════════════════════════════════════════════════════════════════════
  #  HOME MANAGER SETUP
  # ═══════════════════════════════════════════════════════════════════════════
  programs.home-manager.enable = true;
}

