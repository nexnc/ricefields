/*
  ╔═══════════════════════════════════════════════════════════════════════════╗
  ║                                                                           ║
  ║        ███╗   ██╗███████╗██╗  ██╗███╗   ██╗ ██████╗                       ║
  ║        ████╗  ██║██╔════╝╚██╗██╔╝████╗  ██║██╔════╝                       ║
  ║        ██╔██╗ ██║█████╗   ╚███╔╝ ██╔██╗ ██║██║                            ║
  ║        ██║╚██╗██║██╔══╝   ██╔██╗ ██║╚██╗██║██║                            ║
  ║        ██║ ╚████║███████╗██╔╝ ██╗██║ ╚████║╚██████╗                       ║
  ║        ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝                       ║
  ║                                                                           ║
  ║   NixOS 25.11 (Xantusia) • Hyprland • Zen Kernel                          ║
  ║   User: nexnc • Host: nixos                                               ║
  ║                                                                           ║
  ╚═══════════════════════════════════════════════════════════════════════════╝
*/

{ config, pkgs, inputs, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # BOOTLOADER & KERNEL
  # ═══════════════════════════════════════════════════════════════════════════
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;  # Keep only last 10 generations in boot menu
        consoleMode = "max";       # Use maximum resolution
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;  # Boot menu timeout in seconds
    };
    kernelPackages = pkgs.linuxPackages_zen; # Performance-optimized kernel
    
    # Silent boot (optional - uncomment if you want a cleaner boot)
    kernelParams = [ "quiet" "splash" ];
    consoleLogLevel = 3;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NIX CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  nix = {

    registry = {
      # This creates your 'univ' macro
      univ.to = {
        type = "path";
        path = "/etc/nixos/templates";
      };

      # This pins 'nixpkgs' to your system version and fixes the error
      nixpkgs.flake = inputs.nixpkgs;
    };

    settings = {
      # Flakes & nix-command
      experimental-features = [ "nix-command" "flakes" ];
      
      # Performance optimizations
      download-buffer-size = 268435456;  # 256 MB for 300mbps connection
      max-jobs = "auto";                  # Parallel builds
      cores = 0;                          # Use all CPU cores
      
      # Build optimization
      auto-optimise-store = true;         # Automatically deduplicate store
      
      # Substituters (binary caches)
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    
    # Optimize store weekly
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
  
  nixpkgs.config.allowUnfree = true;

   # ═══════════════════════════════════════════════════════════════════════════
  # NETWORKING & LOCALIZATION
  # ═══════════════════════════════════════════════════════════════════════════
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;

    # Firewall configuration
    firewall = {
      enable = true;
      trustedInterfaces = ["virbr0"];

      allowedTCPPorts = [ 56000 ]; 
      allowedUDPPorts = [ 56000 ];

      allowedTCPPortRanges = [ 
        { from = 1714; to = 1764; }  # KDE Connect / Valent
      ];
      allowedUDPPortRanges = [ 
        { from = 1714; to = 1764; }  # KDE Connect / Valent
      ];
    };
  };
  
  # Time & Locale
  time.timeZone = "Asia/Kolkata";
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS        = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT    = "en_IN";
      LC_MONETARY       = "en_IN";
      LC_NAME           = "en_IN";
      LC_NUMERIC        = "en_IN";
      LC_PAPER          = "en_IN";
      LC_TELEPHONE      = "en_IN";
      LC_TIME           = "en_IN";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # HARDWARE CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  hardware = {
    i2c.enable = true;
    # Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Experimental = true;
        Enable = "Source,Sink,Media,Socket";
      };
    };
    
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    amdgpu = {
      initrd.enable = true;
      opencl.enable = true; # ROCm OpenCL for AMD GPUs
    };
  };

   
  # ═══════════════════════════════════════════════════════════════════════════
  # MEMORY MANAGEMENT
  # ═══════════════════════════════════════════════════════════════════════════

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 12;  # ~3GB ZRAM
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };  

  # ═══════════════════════════════════════════════════════════════════════════
  # AUDIO (PIPEWIRE)
  # ═══════════════════════════════════════════════════════════════════════════
  security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # DESKTOP ENVIRONMENT (HYPRLAND)
  # ═══════════════════════════════════════════════════════════════════════════
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Display Manager (greetd + tuigreet)
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --cmd Hyprland";
      user = "greeter";
    };
  };

  # XDG Portals for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Input & Console
  services.xserver.xkb = { 
    layout = "us";
    variant = ""; 
  };
  console.keyMap = "us";

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-color-emoji
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # FILESYSTEMS & STORAGE
  # ═══════════════════════════════════════════════════════════════════════════
  # Auto-mounting services
  
  programs.gnome-disks.enable = true;

  # Custom auto-mount point
  fileSystems."/mnt/Data" = {
    device = "UUID=d60c75ae-fc6a-4491-b591-91397bd46aaf";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # USER CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════

  users.mutableUsers = false;
  users.users.nexnc = {
    isNormalUser = true;
    description = "NEXNC";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "i2c" 
      "libvirtd"
      "video"      # For brightness control
      "audio" 
      "render" # For audio devices
    ];
    shell = pkgs.fish;
  };

  # Greetd user configuration
  users.users.greeter = {
    isSystemUser = true;
    shell = pkgs.fish;  # or pkgs.bash
  };


  # Home Manager integration
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    users."nexnc" = import ../../home/home.nix;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # VIRTUALIZATION & CONTAINERS
  # ═══════════════════════════════════════════════════════════════════════════
  virtualisation = {
    # Podman (Docker alternative)
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;  # Docker compatibility
      defaultNetwork.settings.dns_enabled = true;

    };
    
    # QEMU/KVM with libvirt
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
      };
    };
    
    spiceUSBRedirection.enable = true;
  };
  
  programs.virt-manager.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEM SERVICES
  # ═══════════════════════════════════════════════════════════════════════════
  services = {

    gvfs.enable    = true;
    udisks2.enable = true;
    blueman.enable = true;
    tumbler.enable = true;

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;  # Security: key-only authentication
        PermitRootLogin = "no";          # Security: disable root login
      };
    };
    
    printing.enable = true;
    flatpak.enable = true;
  };
  
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.fish.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEM PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # ─── Core Utilities ────────────────────────────────────────────────────
    busybox
    wget
    curl
    
    # ─── Filesystem & Disks ────────────────────────────────────────────────
    gparted
    udiskie
    
    # ─── Hyprland Ecosystem ────────────────────────────────────────────────
    hyprpolkitagent
    wl-clipboard       # Wayland clipboard utilities
    
    # ─── Audio & Hardware ──────────────────────────────────────────────────
    pavucontrol
    ddcutil
    
    # ─── Containers & VM ───────────────────────────────────────────────────
    podman-tui
    podman-compose
    slirp4netns
    fuse-overlayfs

   
    
    # ─── System Libraries ─────────────────────────────────────────────────
    libsecret
    sops
    age
    gamemode
    vulkan-tools
    vulkan-loader
    amdgpu_top
    mangohud
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # SECURITY
  # ═══════════════════════════════════════════════════════════════════════════
  security = {
    polkit.enable = true;
    sudo.wheelNeedsPassword = true;  # Require password for sudo
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # KEYRINGS AND SECRETS MANAGEMENT
  # ═══════════════════════════════════════════════════════════════════════════

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # SOPS-NIX CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════

  sops = {
    # Private age key used to decrypt the file
    age.keyFile = "/var/lib/sops-nix/key.txt";
    defaultSopsFile = ../../secrets/user-password.yaml;
  };

  # Use the decrypted password to set user's password
  sops.secrets.password = {
    sopsFile = ../../secrets/user-password.yaml;
    owner = "root";
    group = "root";
    mode = "0400";
    neededForUsers = true;

  };

  sops.secrets.root_password = {
    sopsFile = ../../secrets/user-password.yaml;
    neededForUsers = true;

  };

  # Cloudflare token secret
  sops.secrets."cloudflared-token" = {
    sopsFile = ../../secrets/cloudflared.yaml;
    owner = "root";
    group = "root";
    mode = "0444";
  };

  # Assign decrypted password to user and root
  users.users.nexnc.hashedPasswordFile = config.sops.secrets.password.path;
  users.users.root.hashedPasswordFile = config.sops.secrets.root_password.path;


  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEM UPDATE
  # ═══════════════════════════════════════════════════════════════════════════

  system.autoUpgrade = {
    enable = false;
    allowReboot = false;
  };



  # ═══════════════════════════════════════════════════════════════════════════
  # ENVIRONMENT SESSION VARIABLES
  # ═══════════════════════════════════════════════════════════════════════════

  environment.sessionVariables = {
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/glib-2.0/schemas";
    
    # Force Vulkan to use the AMD RADV driver and ignore llvmpipe (CPU)
    AMD_VULKAN_ICD = "RADV";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  };

  environment.profileRelativeEnvVars.XDG_DATA_DIRS = [ "share" ];


  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEM STATE VERSION
  # ═══════════════════════════════════════════════════════════════════════════
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of your first install.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  
  system.stateVersion = "24.11";  # Did you read the comment?
}

# ═══════════════════════════════════════════════════════════════════════════
# NOTES & TODO
# ═══════════════════════════════════════════════════════════════════════════
# 
# Next improvements to consider:
# - [ ] Enable auto-upgrade: system.autoUpgrade.enable = true;
# - [ ] Set up automated backups with restic or borg
# - [ ] Configure firewall rules for specific services
# - [ ] Add custom kernel parameters if needed
# - [ ] Set up ZFS or BTRFS snapshots if using those filesystems
# 
# ═══════════════════════════════════════════════════════════════════════════


