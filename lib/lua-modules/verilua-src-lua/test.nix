let
  npinsed = import ../../../npins;
  pkgs = import npinsed.nixpkgs {};
  luajit-pro = import ../../../luajit-pro;
  luaPackages = luajit-pro.pkgs;
  inherit (luaPackages.lua) luaversion;
  dut = import ./.;
in pkgs.lib.runTests {
  # Test main Lua files exist
  test-main-files = pkgs.lib.testAllTrue [
    (builtins.pathExists (dut + /share/lua/${luaversion}/verilua/Verilua.lua))
    (builtins.pathExists (dut + /share/lua/${luaversion}/verilua/init.lua))
    (builtins.pathExists (dut + /share/lua/${luaversion}/meta.lua))
    (builtins.pathExists (dut + /share/lua/${luaversion}/verilua/strict.lua))
  ];

  # Test key module files exist
  test-key-modules = pkgs.lib.testAllTrue [
    (builtins.pathExists (dut + /share/lua/${luaversion}/verilua/LuaDut.lua))
    (builtins.pathExists (dut + /share/lua/${luaversion}/verilua/LuaSimulator.lua))
    (builtins.pathExists (dut + /share/lua/${luaversion}/verilua/LuaUtils.lua))
    (builtins.pathExists (dut + /share/lua/${luaversion}/verilua/TccWrapper.lua))
  ];

  # Test subdirectory module files exist
  test-subdir-modules = pkgs.lib.testAllTrue [
    (builtins.pathExists (dut + /share/lua/${luaversion}/verilua/utils/BitVec.lua))
    (builtins.pathExists (dut + /share/lua/${luaversion}/verilua/scheduler/LuaScheduler.lua))
    (builtins.pathExists (dut + /share/lua/${luaversion}/verilua/handles/LuaBundle.lua))
    (builtins.pathExists (dut + /share/lua/${luaversion}/verilua/coverage/CoverGroup.lua))
  ];

  # Test thirdparty_lib files exist
  test-thirdparty-lib = pkgs.lib.testAllTrue [
    (builtins.pathExists (dut + /share/lua/${luaversion}/thirdparty_lib/json.lua))
    (builtins.pathExists (dut + /share/lua/${luaversion}/thirdparty_lib/inspect.lua))
    (builtins.pathExists (dut + /share/lua/${luaversion}/thirdparty_lib/fun.lua))
  ];
}
