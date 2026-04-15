let
  npinsed = import ../../../npins;
  pkgs = import npinsed.nixpkgs {};
  luaPackages = (import ../../../luajit-pro).pkgs;
  inherit (luaPackages.lua) luaversion;
  debugger-lua = import ./.;
in pkgs.lib.runTests {
  test-debugger-lua = pkgs.lib.testAllTrue [
    (builtins.pathExists "${debugger-lua}/share/lua/${luaversion}/debugger.lua")
  ];
}
