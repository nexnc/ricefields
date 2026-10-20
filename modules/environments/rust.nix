# modules/environments/rust.nix
{ ... }:

let
  pkgNames = [ "rustc" "cargo" "clippy" "rustfmt" "rust-analyzer" ];
in
{
  perSystem = { pkgs, ... }: {
    # local-only shell (still usable via path:/etc/nixos#rust)
    devShells.rust = pkgs.mkShell {
      packages = map (n: pkgs.${n}) pkgNames;
      env = {
        RUST_BACKTRACE = "1";
        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
      };
    };

    # portable flake.nix that nix-init copies into a project
    packages.rust-flake = pkgs.writeText "flake.nix" ''
      {
        description = "Rust dev shell";

        inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

        outputs = { nixpkgs, ... }:
          let
            systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
            forAllSystems = f: nixpkgs.lib.genAttrs systems (s: f nixpkgs.legacyPackages.''${s});
          in {
            devShells = forAllSystems (pkgs: {
              default = pkgs.mkShell {
                packages = with pkgs; [ ${builtins.concatStringsSep " " pkgNames} ];
                env = {
                  RUST_BACKTRACE = "1";
                  RUST_SRC_PATH = "''${pkgs.rustPlatform.rustLibSrc}";
                };
              };
            });
          };
      }
    '';
  };
}
