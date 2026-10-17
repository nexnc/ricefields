{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sequoia-sq
    sequoia-chameleon-gnupg
  ];
}
