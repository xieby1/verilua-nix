let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  lsqlite = import ./.;
  dir = builtins.readDir "${lsqlite}/lib/lua/5.1";
in pkgs.lib.runTests {
  test-so = pkgs.lib.testAllTrue [
    (dir ? "lsqlite3.so")
  ];
}
