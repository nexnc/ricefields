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

    # ─── Gaming ────────────────────────────────────────────────────────────────
    prismlauncher
    bottles

    # ─── Development ───────────────────────────────────────────────────────────
    python3
    cargo
    rustc
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

    # ─── Terminal Tools ────────────────────────────────────────────────────────
    tmux
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
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  #  FILE MANAGEMENT
  # ═══════════════════════════════════════════════════════════════════════════
  home.file = { 
    # ".config/hypr/hyprland.conf".source = ./dotfiles/hyprland.conf;
  };

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

