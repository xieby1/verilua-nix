let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  luajit-pro = import <luajit-pro>;
  cluacov = pkgs.callPackage ./. { luaPackages = luajit-pro.pkgs; };
  out = cluacov.outPath;
in pkgs.lib.runTests {
  test-out = pkgs.lib.testAllTrue [
    (builtins.pathExists (out + "/lib/lua/5.1/cluacov/deepactivelines.so"))
    (builtins.pathExists (out + "/lib/lua/5.1/cluacov/hook.so"))
    (builtins.pathExists (out + "/share/lua/5.1/cluacov/version.lua"))
  ];
}
