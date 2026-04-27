{ config, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true; # Autogenerates 'fzf --fish | source'
    
    # Optional: nicer colors to match your theme
    # colors = {
    #   "fg+" = "#cdd6f4";
    #   "bg+" = "#313244";
    #   "hl+" = "#f38ba8";
    #   # ... etc (Catppuccin Mocha example)
    # };
  };
}
