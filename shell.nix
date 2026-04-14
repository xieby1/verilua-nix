let
  pkgs = import (import ./npins).nixpkgs {};
in pkgs.mkShell {
  name = "verilua-nix";
  packages = [
    pkgs.npins
  ];
  shellHook = ''
    export NIX_PATH=npins=$(realpath ./npins/):luajit-pro=$(realpath ./luajit-pro/);
  '';
}
