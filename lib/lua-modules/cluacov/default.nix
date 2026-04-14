{
  buildLuarocksPackage,
  luacov,
}:
buildLuarocksPackage {
  pname = "cluacov";
  version = "scm-1";
  src = (import ../../../npins).cluacov;
  propagatedBuildInputs = [
    luacov
  ];
}

