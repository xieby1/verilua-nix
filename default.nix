# IMPORTANT: ./default.nix (this file) should be used independently from ./shell.nix, therefore:
# - `<npins>` and `<luajit-pro>` are unavailable since $NIX_PATH does not define them.
# - `<nixpkgs>` is avoided for purity. Use `npinsed.nixpkgs` instead.
let
  npinsed = import ./npins;
  pkgs = import npinsed.nixpkgs {};
  luajit-pro-with-packages = (import ./luajit-pro).withPackages (luaPackages: [
    luaPackages.penlight
    luaPackages.luasocket
    luaPackages.linenoise
    luaPackages.argparse
    (import ./lib/lua-modules/cluacov)
    (import ./lib/lua-modules/lsqlite {complete = false;})
    (import ./lib/lua-modules/lsqlite {complete = true;})
    (import ./lib/lua-modules/tcc)
    (import ./lib/lua-modules/verilua)
    (import ./lib/lua-modules/thirdparty_lib)
    (import ./lib/lua-modules/verilua-src-lua)
    # TODO: The submodule debugger.lua is redundant, can be removed
    (import ./lib/lua-modules/debugger-lua)
  ]);
  verilua_home = pkgs.symlinkJoin {
  verilua_home = pkgs.applyPatches {
    name = "VERILUA_HOME";
    src = npinsed.verilua;
    postPatch = ''
      patchShebangs .
      mkdir -p tools
      ln -s ${import ./lib/testbench_gen}/bin/testbench_gen tools/

      ln -s ${luajit-pro-with-packages}/include luajit-pro/luajit2.1/
      ln -s ${luajit-pro-with-packages}/lib luajit-pro/luajit2.1/

      mkdir -p conan_installed/include
      mkdir -p conan_installed/lib

      mkdir -p shared
    '';
  };
in pkgs.stdenv.mkDerivation {
  name = "verilua-env";
  dontUnpack = true;
  # TODO: The following dependencies are currently not used by default.nix,
  #       which means the examples can be run without these dependencies.
  #       Are these dependencies redundant?
  #       pkgs.gmp
  #       pkgs.tinycc
  #       (import ./lib/signal_db_gen)
  #       (import ./lib/dpi_exporter)
  #       (import ./lib/cov_exporter)
  propagatedBuildInputs = [
    (import ./xmake)
    luajit-pro-with-packages
    (import ./lib/libverilua)
    (import ./lib/wave_vpi)
    (import ./lib/testbench_gen)
  ];
  shellHook = ''
    export VERILUA_HOME=${verilua_home}

    # TODO: pkgs.luajit.pkgs.wrapLua
    # As nixpkgs has auto set LUA_PATH and LUA_CPATH of luajit-pro.withPackages(...),
    # why we still need to export?
    # Because of xmake!
    # Xmake embed a lua/luajit in its binary. It does not utilize the user's lua.
    # So to xmake happy (xmake needs to access verilua lua files), we need to export LUA_PATH and LUA_CPATH.
    export LUA_PATH=${luajit-pro-with-packages.luaPath}
    export LUA_CPATH=${luajit-pro-with-packages.luaCpath}
  '';
  installPhase = ''
    # Ensure $out exists so stdenv can create $out/nix-support/ (required for propagated-build-inputs).
    mkdir $out
  '';
}
