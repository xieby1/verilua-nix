let
  npinsed = import ./npins;
  pkgs = import npinsed.nixpkgs {};
in pkgs.mkShell {
  name = "verilua-nix";
  packages = [
    pkgs.npins
  ];
  shellHook = ''
    export NIX_PATH=nixpkgs=${npinsed.nixpkgs}:npins=$(realpath ./npins/):luajit-pro=$(realpath ./luajit-pro/);
  '';
}
