let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  luaPackages = (import <luajit-pro>).pkgs;
  inherit (luaPackages.lua) luaversion;
  tcc-module = import ./.;
in pkgs.lib.runTests {
  test-tcc-lua = pkgs.lib.testAllTrue [
    (builtins.pathExists "${tcc-module}/share/lua/${luaversion}/tcc.lua")
  ];
}
