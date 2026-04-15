let
  luaPackages = (import ../../../luajit-pro).pkgs;
in luaPackages.buildLuarocksPackage {
  pname = "cluacov";
  version = "scm-1";
  src = (import ../../../npins).cluacov;
  propagatedBuildInputs = [
    # `<luacov>/bin/*` pulls in luarock_bootstrap as a dependency (~100MB).
    # Verilua only needs the Lua scripts, not the binaries in `<luacov>/bin/*`.
    # Removing that directory avoids the large dependency and reduces the closure size.
    (luaPackages.luacov.overrideAttrs (_old: {postInstall = "rm -rf $out/bin/";}))
  ];
}
