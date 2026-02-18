{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    
    shellInit = ''
      # Disable fish greeting
      set -g fish_greeting ""
      set -gx PATH $HOME/.cargo/bin $PATH
      set -gx GPG_TTY (tty)
    '';
    
    interactiveShellInit = ''

      # Better history search with arrow keys
	

      bind "[A" history-search-backward
      bind "[B" history-search-forward
    '';

    
    shellAbbrs = {
      # Fish management
      fishconfig = "sudo nvim /etc/nixos/home/modules/programs/fish.nix";
      ff = "fastfetch";
      music = "ncmpcpp";
      svim = "sudo nvim";
      
      # NixOS management
      flakeupdate = "sudo nix flake update --flake /etc/nixos#desktop";
      systemupdate = "sudo nixos-rebuild switch --flake /etc/nixos#desktop";
      nixupdate = "sudo nixos-rebuild switch";
      nixconfig = "sudo nvim /etc/nixos/hosts/desktop/configuration.nix";
      homeconfig = "sudo nvim /etc/nixos/home/home.nix";
      
      # Navigation (modern CLI tools)
      cd = "z";  # zoxide replaces cd
      ls = "eza --icons";
      ll = "eza -l --icons --git";
      la = "eza -la --icons --git";
      tree = "eza --tree --icons";
      
      # Search & files
      grep = "rg";
      find = "fd";
      cat = "bat";
      
      # System utilities
      ps = "procs";
      du = "dust";
      df = "duf";
      
      # Git shortcuts
      gst = "git status";
      gd = "git diff";  # Will use delta automatically
      gl = "git log --oneline";
      lg = "lazygit";
      gg = "lazygit";
      
      # System monitoring
      top = "btop";
      net = "sudo bandwhich";
    };
  };
}
