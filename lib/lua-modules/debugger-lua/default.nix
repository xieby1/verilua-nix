let
  npinsed = import ../../../npins;
  luaPackages = (import ../../../luajit-pro).pkgs;
in luaPackages.buildLuarocksPackage {
  pname = "debugger-lua";
  version = "scm-1";
  src = npinsed.verilua + /extern/debugger.lua;
}
