let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  luaPackages = (import <luajit-pro>).pkgs;
  inherit (luaPackages.lua) luaversion;
  verilua = import ./.;
in pkgs.lib.runTests {
  test-verilua = pkgs.lib.testAllTrue [
    (builtins.pathExists "${verilua}/share/lua/${luaversion}/Verilua.lua")
  ];
}
