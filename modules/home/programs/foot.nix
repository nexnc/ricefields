{ config, pkgs, ... }:
{
  programs.foot = {
    enable = true;

    settings = {
      csd = {
        preferred = "none";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
