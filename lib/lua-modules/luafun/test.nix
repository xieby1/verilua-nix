let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  my-derivation = import ./.;
in pkgs.lib.runTests {
  test-luafun-module = pkgs.lib.testAllTrue [
    (builtins.pathExists (my-derivation + /share/lua/5.1/fun.lua))
  ];
}
