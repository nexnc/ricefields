{
  description = "2026 Systems Dev Stack: C++26 Ready, Rust-Bridge, and ASM";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Using unstable for latest versions
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          # --- CORE COMPILERS ---
          gcc15              
          llvmPackages_22.clang
          
          # --- BUILD SYSTEMS ---
          cmake              # 4.2+ (Stable)
          ninja              # High-speed build generator
          
          # --- DIAGNOSTICS & MEMORY ---
          gdb                # debugger
          valgrind           # leak detection
          cppcheck           # Static analysis
          
          # --- LOW LEVEL & ASM ---
          nasm               # x86 Assembler
          binutils           # objdump, readelf, nm
          
          # --- THE PACKAGE MANAGERS ---
          pixi               # For cross-platform project management
        ];

        shellHook = ''
          export CC=clang
          export CXX=clang++
          
          # Fix for Pixi/Conda binaries on NixOS
          export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.zlib pkgs.glibc ]}:$LD_LIBRARY_PATH"

          echo "──────────────────────────────────────────────────"
          echo "   Dev Environment Active"
          echo "  GCC:   $(g++ --version | head -n1)"
          echo "  Clang: $(clang++ --version | head -n1)"
          echo "  CMake: $(cmake --version | head -n1)"
          echo "  Pixi:  $(pixi --version)"
          echo "──────────────────────────────────────────────────"
        '';
      };
    };
}
