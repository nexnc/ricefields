{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Or use flake-utils for multi-system
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.hello ];
        shellHook = "echo 'Empty Nix shell loaded!'";
      };
    };
}
