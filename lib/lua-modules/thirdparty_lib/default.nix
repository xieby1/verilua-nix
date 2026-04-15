let
  luaPackages = (import <luajit-pro>).pkgs;
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  inherit (luaPackages.lua) luaversion;
in luaPackages.toLuaModule (pkgs.runCommand "lua${luaversion}-thirdparty_lib" {} ''
  mkdir -p $out/share/lua/${luaversion}
  cp -sr ${npinsed.verilua + /src/lua/thirdparty_lib}/* $out/share/lua/${luaversion}
'')
