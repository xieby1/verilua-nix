let
  npinsed = import ../../npins;
  pkgs = import npinsed.nixpkgs {};
in pkgs.mkShell {
  name = "verilua-self-test";
  inputsFrom = [(import ../../.)];
  buildInputs = [
    pkgs.verilator
  ];
}

