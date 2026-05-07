{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [ 
          cargo 
          rustc 
          rust-analyzer 
          clippy 
          rustfmt 
        ];
        shellHook = "echo '🦀 Rust environment loaded'";
      };
    };
}
