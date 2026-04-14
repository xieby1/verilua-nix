{
  # To make the lua module more versatile, we use `luaPackages` here, which can be:
  # - luaPackages (alias of lua.pkgs),
  # - luajitPackages (alias of luajit.pkgs),
  # - and luajit-pro.pkgs, which is used in current repo.
  luaPackages,
}:
luaPackages.buildLuarocksPackage {
  pname = "cluacov";
  version = "scm-1";
  src = (import <npins>).cluacov;
  propagatedBuildInputs = [
    luaPackages.luacov
  ];
}

