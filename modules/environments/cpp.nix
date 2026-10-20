# modules/environments/cpp.nix
{ ... }:

let
  # Nix expressions as text, so they work both in `with pkgs;` and via attrByPath
  pkgNames = [
    "gcc15" "llvmPackages_22.clang"        # compilers
    "cmake" "ninja"                        # build systems
    "gdb" "valgrind" "cppcheck"            # diagnostics
    "nasm" "binutils"                      # low level
    "pixi"                                 # package manager
  ];

  # shellHook text, parameterised on how pixiLibs is spelled in each context
  hook = libs: ''
    export CC=clang
    export CXX=clang++
    export PIXI_NIX_LIBS="${libs}"

    echo "──────────────────────────────────────────────────"
    echo "   C++ Dev Environment Active"
    echo "   GCC:   $(g++ --version | head -n1)"
    echo "   Clang: $(clang++ --version | head -n1)"
    echo "   CMake: $(cmake --version | head -n1)"
    echo "   Pixi:  $(pixi --version)"
    echo "──────────────────────────────────────────────────"
  '';
in
{
  perSystem = { pkgs, ... }:
    let
      lib = pkgs.lib;
      # Libs that Pixi/Conda-managed binaries need at runtime.
      pixiLibs = lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib # libstdc++
        pkgs.zlib
      ];
    in
    {
      devShells.cpp = pkgs.mkShell {
        packages = map (n: lib.getAttrFromPath (lib.splitString "." n) pkgs) pkgNames;
        shellHook = hook pixiLibs;
      };

      # portable flake.nix that nix-init copies into a project
      packages.cpp-flake = pkgs.writeText "flake.nix" ''
        {
          description = "C++ dev shell";

          inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

          outputs = { nixpkgs, ... }:
            let
              # valgrind/gdb/nasm are not available on darwin, so linux only
              systems = [ "x86_64-linux" "aarch64-linux" ];
              forAllSystems = f: nixpkgs.lib.genAttrs systems (s: f nixpkgs.legacyPackages.''${s});
            in {
              devShells = forAllSystems (pkgs:
                let
                  pixiLibs = pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.zlib ];
                in {
                  default = pkgs.mkShell {
                    packages = with pkgs; [ ${builtins.concatStringsSep " " pkgNames} ];
                    shellHook = '''
                      ${hook "\${pixiLibs}"}
                    ''';
                  };
                });
            };
        }
      '';
    };
}
