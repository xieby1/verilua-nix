let
  luaPackages = (import ../../../luajit-pro).pkgs;
in luaPackages.buildLuarocksPackage {
  pname = "cluacov";
  version = "scm-1";
  src = (import ../../../npins).cluacov;
  propagatedBuildInputs = [
    luaPackages.luacov
  ];
}
