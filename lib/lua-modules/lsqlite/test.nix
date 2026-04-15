let
  npinsed = import ../../../npins;
  pkgs = import npinsed.nixpkgs {};
  lsqlite = import ./. { complete = false; };
  lsqlite-complete = import ./. { complete = true; };
in pkgs.lib.runTests {
  test-so = pkgs.lib.testAllTrue [
    ((builtins.readDir "${lsqlite}/lib/lua/5.1") ? "lsqlite3.so")
    ((builtins.readDir "${lsqlite-complete}/lib/lua/5.1") ? "lsqlite3complete.so")
  ];
}
