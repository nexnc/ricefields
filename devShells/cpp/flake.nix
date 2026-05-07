{
  description = "C++26, Rust-Bridge, and ASM";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Libs that Pixi/Conda-managed binaries need at runtime.
      # Exposed as a named var — NOT injected into LD_LIBRARY_PATH —
      # so the rest of the shell (your terminal, editor, etc.) is unaffected.
      pixiLibs = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib  # libstdc++
        pkgs.zlib
        # NOTE: glibc is intentionally omitted. Injecting a different glibc
        # into LD_LIBRARY_PATH almost always causes SIGSEGV in system binaries.
        # If a pixi binary truly needs it, run it with:
        #   LD_LIBRARY_PATH=$PIXI_NIX_LIBS:$(nix-build -A glibc.lib '<nixpkgs>')/lib ./binary
      ];
    in {
      devShells.${system}.default = pkgs.mkShell {
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
          # Compiler selection: clang as default, gcc15 available as g++
          export CC=clang
          export CXX=clang++

          # Pixi/Conda binaries are dynamically linked against non-Nix libs.
          # Use this var when running a pixi-managed binary that fails to load:
          #
          #   LD_LIBRARY_PATH=$PIXI_NIX_LIBS ./your-binary
          #
          # Or in pixi.toml tasks:
          #   [tasks.run]
          #   cmd = "your-binary"
          #   env = { LD_LIBRARY_PATH = "$PIXI_NIX_LIBS" }
          export PIXI_NIX_LIBS="${pixiLibs}"

          echo "──────────────────────────────────────────────────"
          echo "   Dev Environment Active"
          echo "  GCC:   $(g++ --version | head -n1)"
          echo "  Clang: $(clang++ --version | head -n1)"
          echo "  CMake: $(cmake --version | head -n1)"
          echo "  Pixi:  $(pixi --version)"
          echo "──────────────────────────────────────────────────"
        '';
      };
    };
}

