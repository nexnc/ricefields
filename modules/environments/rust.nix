# modules/environments/rust.nix
{ ... }:

{
  perSystem = { pkgs, ... }: {
    devShells.rust = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        rustc
        cargo
        clippy
        rustfmt
        rust-analyzer
      ];

      env = {
        RUST_BACKTRACE = "1";
      };
    };
  };
}
