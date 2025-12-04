{ config, pkgs, ... }:



{
  home.username = "nexnc";
  home.homeDirectory = "/home/nexnc";
  home.stateVersion = "25.05";

  imports = [
  
  # Desktop
   ./modules/desktop

  # Programs

  ./modules/programs
 
  # Services
  ./modules/services

  ];

  home.packages = with pkgs; [
    # Browsers & Communication
    librewolf
    thunderbird
    signal-desktop

    # Media & Entertainment
    mpv
    freetube

    # Productivity & Creation
    obs-studio
    gimp

    # Gaming
    prismlauncher
    bottles

    # Developement
    python3
    cargo
    rustc
    nmap
    gcc
    uv

    # Desktop Utilities
    fastfetch
    yt-dlp
    aria2
    p7zip
    exiftool
    nsxiv
    qbittorrent

    # Terminal
    tmux
    wl-clipboard
    cliphist
    eza
    ripgrep
    fd
    bat
    du-dust
    duf
    gdu
    tldr
    delta
    tokei
    btop
    bandwhich
    just
    hyperfine
  ];

  home.file = { };

  home.sessionVariables = {
  EDITOR = "nvim";
  VISUAL = "nvim";
  TERMINAL = "foot";
  BROWSER = "librewolf";

  XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
  XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
  XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";


  # Better CLI tools
  #PAGER = "less";
  #MANPAGER = "less";
  #LESSHISTFILE = "-"; # optional, disables .lesshst

  # Wayland
  MOZ_ENABLE_WAYLAND = "1";
  XDG_CURRENT_DESKTOP = "Hyprland";
  XDG_SESSION_TYPE = "wayland";
  };

  programs.home-manager.enable = true;
}
