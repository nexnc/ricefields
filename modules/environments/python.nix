# modules/environments/python.nix
{ ... }:

{
  perSystem = { pkgs, ... }: {
    devShells.python = pkgs.mkShell {
      packages = with pkgs; [
        python3
        uv
      ];

      shellHook = ''
        echo "──────────────────────────────────────────────────"
        echo "   Python (uv) Environment Active"
        echo "   Python: $(python3 --version)"
        echo "   uv:     $(uv --version)"
        echo "──────────────────────────────────────────────────"
      '';
    };
  };
}
