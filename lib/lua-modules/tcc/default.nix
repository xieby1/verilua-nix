let
  npinsed = import ../../../npins;
  pkgs = import npinsed.nixpkgs {};
  luaPackages = (import ../../../luajit-pro).pkgs;
  inherit (luaPackages.lua) luaversion;
in luaPackages.toLuaModule (pkgs.runCommand "lua${luaversion}-tcc" {} ''
  mkdir -p $out/share/lua/${luaversion}
  cp -s ${npinsed.verilua}/extern/luajit_tcc/tcc.lua $out/share/lua/${luaversion}
'')
