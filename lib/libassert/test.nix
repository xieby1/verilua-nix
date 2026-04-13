let
  npinsed = import ../../npins;
  pkgs = import npinsed.nixpkgs {};
  libassert = import ./.;
in pkgs.lib.runTests {
  test-lib = pkgs.lib.testAllTrue [
    (builtins.pathExists (libassert + "/lib/libassert.a"))
    (builtins.pathExists (libassert + "/include/libassert/assert.hpp"))
  ];
}
