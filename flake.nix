{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ ];
      };
      lib_paths = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.xorg.libX11
      ];
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git
          pkg-config

          python3
          poetry
          conda

          stdenv.cc.cc.lib
          xorg.libX11
        ];
        shellHook = ''
          export LD_LIBRARY_PATH="${lib_paths}:$LD_LIBRARY_PATH"
        '';
      };
    });
}
