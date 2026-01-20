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
    # Desktop Environment Settings (Hyprland, Waybar, etc.)
    ./modules/desktop

    # User Programs (Git, Neovim, etc.)
    ./modules/programs
 
    # User Services (Syncthing, MPD, etc.)
    ./modules/services
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

    # ─── Media & Entertainment ─────────────────────────────────────────────────
    mpv
    freetube

    # ─── Productivity & Creation ───────────────────────────────────────────────
    obs-studio
    gimp
    davinci-resolve
    kicad
    godot

    # ─── Gaming ────────────────────────────────────────────────────────────────
    prismlauncher
    gamescope
    winetricks
    wine-wayland
    wine64
    steam

    # ─── Development ───────────────────────────────────────────────────────────
    python3
    rustup
    nmap
    gcc
    uv

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
    universal-android-debloater

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

    # ─── Nix ────────────────────────────────────────────────────────

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
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE    = "wayland";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  #  HOME MANAGER SETUP
  # ═══════════════════════════════════════════════════════════════════════════
  programs.home-manager.enable = true;
}

