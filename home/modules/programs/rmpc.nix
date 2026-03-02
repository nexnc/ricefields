{ config, pkgs, inputs, ... }:

{
  programs.rmpc = {
    enable = true;
    config = ''
      (
        address: "127.0.0.1:6600",
        theme: Some("cyan-wave"), # We define this below
        cache_dir: Some("/tmp/rmpc/cache"),
        on_song_change: None,
        volume_step: 5,
        album_art: (
          method: Kitty, # Since you use 'foot', this is native and fast!
          max_size_px: (width: 300, height: 300),
          vertical_align: Top,
          horizontal_align: Left,
        ),
        keybinds: (
          global: {
            "j": Down,
            "k": Up,
            "h": Left,
            "l": Right,
            "g": Top,
            "G": Bottom,
            "n": NextResult,
            "N": PreviousResult,
            "<C-u>": UpHalf,
            "<C-d>": DownHalf,
            "p": TogglePause,
          },
        ),
      )
    '';
  };

  # Define the theme to match cyan look
  home.file.".config/rmpc/themes/cyan-wave.ron".text = ''
    (
      text_color: "white",
      header_background_color: "black",
      progressbar_color: "cyan",
      symbols: (
        song: "🎵",
        dir: "📁",
        marker: "»",
      ),
    )
  '';
}
