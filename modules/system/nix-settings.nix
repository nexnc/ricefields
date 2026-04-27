{ inputs, pkgs, ... }:
{
  nix = {
    registry = {
      project.to = {
        type = "path";
        path = "/etc/nixos/templates";
      };
      nixpkgs.flake = inputs.nixpkgs;
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      download-buffer-size = 268435456;
      max-jobs = "auto";
      cores = 0;
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://niri.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
