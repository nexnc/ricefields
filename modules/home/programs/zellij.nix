{ config, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;

    settings = {
      theme = "catppuccin-mocha";

      # UI Tweaks
      show_startup_tips = false;
      mouse_mode = true;
      pane_frames = false;
      default_layout = "compact";
      simplified_ui = true;

      # Behavior
      default_mode = "normal";
      on_force_close = "detach";
      
    };
  };
}
