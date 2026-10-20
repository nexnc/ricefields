# modules/environments/python.nix
{ ... }:

let
  pkgNames = [ "python3" "uv" ];

  hook = ''
    echo "──────────────────────────────────────────────────"
    echo "   Python (uv) Environment Active"
    echo "   Python: $(python3 --version)"
    echo "   uv:     $(uv --version)"
    echo "──────────────────────────────────────────────────"
  '';
in
{
  perSystem = { pkgs, ... }: {
    devShells.python = pkgs.mkShell {
      packages = map (n: pkgs.${n}) pkgNames;
      shellHook = hook;
    };

    packages.python-flake = pkgs.writeText "flake.nix" ''
      {
        description = "Python dev shell";

        inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

        outputs = { nixpkgs, ... }:
          let
            systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
            forAllSystems = f: nixpkgs.lib.genAttrs systems (s: f nixpkgs.legacyPackages.''${s});
          in {
            devShells = forAllSystems (pkgs: {
              default = pkgs.mkShell {
                packages = with pkgs; [ ${builtins.concatStringsSep " " pkgNames} ];
                shellHook = '''
                  ${hook}
                ''';
              };
            });
          };
      }
    '';
  };
}
