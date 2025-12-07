# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.

	./hardware-configuration.nix

    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.useNetworkd = true;
  # networking.useDHCP = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };


  # Enable Flakes
  
  nix.settings = {

     experimental-features = [ "nix-command" "flakes" ]; # Enable Flakes
     download-buffer-size = 268435456;  # 256 MB buffer size
     max-jobs = "auto";  # Parallel Builds
     cores = 0;  # use all available cores

  };

  # Enable Greetd with tuigreet

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --cmd Hyprland";
        user = "greeter";
      };
    };
  }; 

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "us";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Fonts

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;


  # Sound Configuration
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

 
  # Bluetooth Configuration
  services.blueman.enable = true;
  hardware.enableAllFirmware = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Show battery charge for BT devices
        # This line is crucial for the A2DP Sink profile to be enabled
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nexnc = {
    isNormalUser = true;
    description = "NEXNC";
    extraGroups = [ "networkmanager" "wheel" "i2c"];
    shell = pkgs.fish;
    packages = with pkgs; [

	# List your user specific packages here
    ];
  };

  # Home Manager

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit  inputs;};
    backupFileExtension = "backup";
    users = {

      "nexnc" = import ./home/home.nix;		     

    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Hyprland

  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };


  # Additional Program

  programs.fish.enable = true;
  programs.gnome-disks.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  # Hardware
  hardware.graphics.enable = true;
  hardware.i2c.enable = true;

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };


  # Disk Management
  fileSystems."/mnt/Data" = {
    device = "UUID=d60c75ae-fc6a-4491-b591-91397bd46aaf";
    fsType = "ext4";
    options = [ "nofail" ];  # ensures boot succeeds even if disk is missing
  };



  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  
  # System utilities
  wget
  git
  gparted
  udiskie
  busybox
  stow
  libmtp
  jmtpfs
  gvfs
  mtpfs
  podman-tui
  
  # System-level Hyprland components
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
  hyprpolkitagent
  
  # Hardware utilities
  ddcutil
  
  # Audio (system-level)
  pavucontrol

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
   
  # Additional Programs
  programs.thunar.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.flatpak.enable = true;

  # Virtualization

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["nexnc"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # Open ports in the firewall.
  networking.firewall = { 
  enable = true;
  
  # Specific Port:
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];

  # Port Ranges:
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
