let
  pkgs = import (import ./npins).nixpkgs {};
in pkgs.mkShell {
  name = "verilua-nix";
  packages = [
    pkgs.npins
  ];
  shellHook = ''
    export NPINS_DIRECTORY=$(realpath ./npins/)
    export NIX_PATH=npins=$NPINS_DIRECTORY;
  '';
}
