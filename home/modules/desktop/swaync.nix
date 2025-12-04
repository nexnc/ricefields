{ config, pkgs, ... }:

{
  services.swaync = {
    enable = true;
    
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "user";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-window-width = 500;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
    };

    style = ''
      /* Catppuccin Mocha Theme for SwayNC */
      * {
        font-family: "JetBrainsMono Nerd Font";
      }

      .notification-row {
        outline: none;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: @surface0;
      }

      .notification {
        border-radius: 10px;
        margin: 6px 12px;
        box-shadow: 0 0 0 1px @surface0;
        padding: 0;
      }

      /* Base Colors */
      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color text   #cdd6f4;
      @define-color surface0 #313244;
      @define-color mauve  #cba6f7;

      .control-center {
        background: @base;
        border-radius: 10px;
        border: 2px solid @mauve;
      }

      .control-center-list {
        background: transparent;
      }

      .control-center-list-placeholder {
        opacity: 0.5;
      }

      .floating-notifications {
        background: transparent;
      }

      .blank-window {
        background: alpha(black, 0);
      }

      .widget-title {
        color: @text;
        background: @base;
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        font-size: 1.5rem;
        border-radius: 5px;
      }

      .widget-title > button {
        font-size: 1rem;
        color: @text;
        text-shadow: none;
        background: @surface0;
        box-shadow: none;
        border-radius: 5px;
      }

      .widget-title > button:hover {
        background: @mantle;
      }

      .widget-label {
        margin: 10px 10px 5px 10px;
      }

      .widget-label > label {
        font-size: 1.1rem;
        color: @text;
      }

      .widget-mpris {
        color: @text;
        background: @surface0;
        padding: 5px 10px;
        margin: 10px 10px 5px 10px;
        border-radius: 5px;
      }

      .widget-mpris > box > button:hover {
        background: @mantle;
      }
    '';
  };
}
