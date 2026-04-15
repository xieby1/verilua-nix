let
  npinsed = import ./npins;
  pkgs = import npinsed.nixpkgs {};
in pkgs.mkShell {
  name = "verilua-nix";
  packages = [
    pkgs.npins
  ];
}
