{ config, pkgs, ... }:

{
  programs.wofi = {
    enable = true;
    
    settings = {
      width = 400;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 24;
      gtk_dark = true;
    };

    # Catppuccin Mocha CSS
    style = ''
      window {
        margin: 0px;
        border: 2px solid #cba6f7; /* Mauve */
        background-color: #1e1e2e; /* Base */
        border-radius: 10px;
      }

      #input {
        margin: 5px;
        border: none;
        color: #cdd6f4; /* Text */
        background-color: #313244; /* Surface0 */
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: #1e1e2e; /* Base */
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: #1e1e2e; /* Base */
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #cdd6f4; /* Text */
      }

      #entry:selected {
        background-color: #313244; /* Surface0 */
        font-weight: bold;
      }
    '';
  };
}
