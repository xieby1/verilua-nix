let
  npinsed = import ../../../npins;
  pkgs = import npinsed.nixpkgs {};
  luaPackages = (import ../../../luajit-pro).pkgs;
  inherit (luaPackages.lua) luaversion;
in luaPackages.toLuaModule (pkgs.runCommand "lua${luaversion}-verilua" {} ''
  mkdir -p $out/share/lua/${luaversion}
  cp -r ${npinsed.verilua}/src/lua/verilua/* $out/share/lua/${luaversion}
'')
