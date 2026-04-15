let
  npinsed = import ../../npins;
  pkgs = import npinsed.nixpkgs {};
  mimalloc2 = import ./.;
  libDir = builtins.readDir "${mimalloc2}/lib";
in pkgs.lib.runTests {
  test-lib = pkgs.lib.testAllTrue [
    (libDir ? "libmimalloc.a")
    (libDir ? "libmimalloc.so")
  ];
}
