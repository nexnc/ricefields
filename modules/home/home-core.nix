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
# HOME CORE  //  dynamic user  //  home-manager 26.05
# user environment: cli tools, programs, services, scripts

{ config, pkgs, lib, osConfig, ... }:

let
  # ▌DEFAULTS
  username = osConfig.user.name;
in
{
  # ▌CORE
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";

  # ▌IMPORTS
  imports = [
    ./programs
    ./services
    ./scripts
  ];

  # ▌PACKAGES
  home.packages = with pkgs; [
    # ── development
    python3
    rustup
    gcc
    uv
    pixi

    # ── terminal utilities
    fastfetch
    ffmpeg
    yt-dlp
    aria2
    p7zip
    exiftool
    filen-cli
    wireguard-tools
    glow
    figlet
    lolcat
    whois
    universal-android-debloater
    android-tools
    bluetui
    usbutils
    pciutils
    ncdu
    rclone

    # ── terminal tools
    wl-clipboard
    cliphist
    eza
    ripgrep
    fd
    bat
    dust
    duf
    gdu
    tldr
    delta
    tokei
    btop
    bandwhich
    just
    hyperfine
    pastebinit

    # ── security
    gpg-tui
    gcr
  ];

  # ▌ENVIRONMENT
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
    TERMINAL = "foot";
  };

  # ▌HOME-MANAGER
  programs.home-manager.enable = true;
}
