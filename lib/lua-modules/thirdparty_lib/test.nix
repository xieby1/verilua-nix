let
  npinsed = import ../../../npins;
  pkgs = import npinsed.nixpkgs {};
  my-derivation = import ./.;
in pkgs.lib.runTests {
  test-lua-modules = let
    lua_modules = [
      "inspect.lua"
      "json.lua"
      "lester.lua"
      "lfs.lua"
      "profile.lua"
      "sqlite3.lua"
      "fun.lua"
    ];
    check-module = mod:
      builtins.pathExists (my-derivation + "/share/lua/5.1/${mod}");
  in pkgs.lib.testAllTrue (map check-module lua_modules);
}
