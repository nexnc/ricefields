{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      opener = {
        image = [
          {
            run = "nsxiv \"$@\"";
            block = false;
            orphan = true;
          }
        ];
      };

      open = {
        rules = [
          {
            mime = "image/*";
            use = "image";
          }
        ];
      };
    };
  };
}

