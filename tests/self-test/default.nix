# If nix-build fails, run it with `nix-build -K ...` to keep the failed build directory and inspect the errors.
let
  npinsed = import ../../npins;
  pkgs = import npinsed.nixpkgs {};
  verilua-env = import ../../.;
in pkgs.stdenv.mkDerivation {
  name = "verilua-self-test";
  buildInputs = [
    pkgs.verilator
    verilua-env
  ];
  dontUnpack = true;
  buildPhase = ''
    ${verilua-env.shellHook}
    mkdir verilua_home
    cd verilua_home/
    cp -rs "$VERILUA_HOME"/* .
    find . -type d -exec chmod +w {} +
    xmake run test
  '';
}

