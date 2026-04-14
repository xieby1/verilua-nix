let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  helper = import ./.;
in pkgs.lib.runTests {
  test-lib = pkgs.lib.testAllTrue [
    (builtins.readDir "${helper.outPath}/lib" == { "libluajit_pro_helper.a" = "regular"; })
  ];
}
