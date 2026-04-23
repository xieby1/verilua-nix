let
  npinsed = import ../../../npins;
  pkgs = import npinsed.nixpkgs {};
  per-simulator = import ./.;
in pkgs.lib.runTests {
  # Test that the built output contains the library for each simulator
  test-supported-simulators = pkgs.lib.testAllTrue (
    map
    (simulator: builtins.pathExists (per-simulator {inherit simulator;} + "/lib/libverilua_${simulator}.so"))
    [
      "verilator"
      "verilator_i"
      "wave_vpi"
      "nosim"
    ]
  );

  # Test that unsupported simulators throw an error
  test-unsupported-simulators = pkgs.lib.testAllTrue (
    map
    (simulator: !(builtins.tryEval (per-simulator {inherit simulator;}).outPath).success)
    [
      "verilator_dpi"
      "vcs"
      "vcs_dpi"
      "xcelium"
      "xcelium_dpi"
      "iverilog"
      "unknown_simulator"
    ]
  );
}
