{ config, pkgs, ... }:

{
services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
    network.listenAddress = "127.0.0.1";
    network.port = 6600;
    
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
      
      audio_output {
        type "fifo"
        name "Visualizer"
        path "/tmp/mpd.fifo"
        format "44100:16:2"
      }
      
      restore_paused "yes"
      auto_update "yes"
    '';
  };

services.mpd-mpris.enable = true;
}
