let
  npinsed = import <npins>;
  luaPackages = (import <luajit-pro>).pkgs;
in luaPackages.buildLuarocksPackage {
  pname = "fun";
  version = "scm-1";
  src = npinsed.luafun;
}

