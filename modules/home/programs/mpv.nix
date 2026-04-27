{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      uosc
      thumbfast
      sponsorblock
      mpris
    ];

    config = {
      osc = "no";
      osd-bar = "no";
      border = "no";
      hwdec = "auto-safe";
      ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
    };

    bindings = {
      "m" = "script-binding uosc/menu";
      "q" = "script-binding uosc/stream-quality";
    };
  };

  home.packages = with pkgs; [
    ytfzf
  ];
}
