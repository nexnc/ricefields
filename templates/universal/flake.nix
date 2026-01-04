{
  description = "Universal Dev Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          # 1. Add your language-specific tools here
          packages = with pkgs; [
            bashInteractive
            # Examples:
            # go, rustc, cargo, nodejs, gcc, gnumake
          ];

          # 2. Add environment variables here
          shellHook = ''
            echo "🚀 Dev environment loaded for ${system}"
            echo "Available tools: $(ls $PATH | grep -E 'python|go|rust|node|gcc' | paste -sd " " -)"
          '';

          # 3. Add environment variables (optional)
          # env = {
          #   DEBUG = "1";
          # };
        };
      });
}
