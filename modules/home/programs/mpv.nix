{ pkgs, ... }:

{
  # Install ytfzf separately for browsing your subscriptions
  home.packages = [ pkgs.ytfzf ];

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      uosc
      thumbfast
      sponsorblock
      return-youtube-dislike
      quality-menu
      mpris
    ];

    config = {
      osc = "no";
      osd-bar = "no";
      border = "no";
      
      # Sponsorblock settings: skip sponsors automatically
      # options: skip, notify, or manual
      sponsorblock-report = "yes";
    };

    bindings = {
      "m" = "script-binding uosc/menu";
      "q" = "script-binding uosc/stream-quality";
      # Press 'D' to see the video statistics, including Dislikes
      "D" = "script-binding uosc/keybinds"; 
    };
  };
}
