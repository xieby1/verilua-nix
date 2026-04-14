let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  libverilua = import ./.;
in pkgs.lib.runTests {
  # Test that all simulator libraries are included via symlinkJoin
  test-all-simulators = pkgs.lib.testAllTrue [
    (builtins.pathExists (libverilua + "/lib/libverilua_verilator.so"))
    (builtins.pathExists (libverilua + "/lib/libverilua_wave_vpi.so"))
    (builtins.pathExists (libverilua + "/lib/libverilua_nosim.so"))
  ];
}
