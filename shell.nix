let
  pkgs = import (import ./npins).nixpkgs {};
in pkgs.mkShell {
  name = "verilua-nix";
  packages = [
    pkgs.npins
  ];
}
