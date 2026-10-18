# modules/environments/cpp.nix
{ ... }:

{
  perSystem = { pkgs, ... }:
    let
      # Libs that Pixi/Conda-managed binaries need at runtime.
      pixiLibs = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib # libstdc++
        pkgs.zlib
      ];
    in
    {
      devShells.cpp = pkgs.mkShell {
        packages = with pkgs; [
          # --- CORE COMPILERS ---
          gcc15
          llvmPackages_22.clang

          # --- BUILD SYSTEMS ---
          cmake
          ninja

          # --- DIAGNOSTICS & MEMORY ---
          gdb
          valgrind
          cppcheck

          # --- LOW LEVEL & ASM ---
          nasm
          binutils

          # --- PACKAGE MANAGERS ---
          pixi
        ];

        shellHook = ''
          export CC=clang
          export CXX=clang++
          export PIXI_NIX_LIBS="${pixiLibs}"

          echo "──────────────────────────────────────────────────"
          echo "   C++ Dev Environment Active"
          echo "   GCC:   $(g++ --version | head -n1)"
          echo "   Clang: $(clang++ --version | head -n1)"
          echo "   CMake: $(cmake --version | head -n1)"
          echo "   Pixi:  $(pixi --version)"
          echo "──────────────────────────────────────────────────"
        '';
      };
    };
}
