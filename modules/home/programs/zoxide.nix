{ config, pkgs, ... }:

{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true; # Autogenerates 'zoxide init fish | source'
    
    # Optional: Replace the 'cd' command with zoxide's 'z'
    options = []; 
  };
}
