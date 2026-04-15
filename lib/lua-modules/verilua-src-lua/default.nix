# TODO: this file is redundant as we already have ../thirdparty_lib and ../verilua
let
  luaPackages = (import ../../../luajit-pro).pkgs;
  npinsed = import ../../../npins;
  pkgs = import npinsed.nixpkgs {};
  inherit (luaPackages.lua) luaversion;
in luaPackages.toLuaModule (pkgs.runCommand "lua${luaversion}-verilua-src-lua" {} ''
  mkdir -p $out/share/lua/${luaversion}
  cp -sr ${npinsed.verilua + /src/lua}/* $out/share/lua/${luaversion}
'')
