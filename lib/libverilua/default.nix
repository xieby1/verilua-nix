let
  pkgs = import <nixpkgs> {};
in pkgs.symlinkJoin {
  name = "libverilua";
  paths = pkgs.lib.map (simulator: import ./per-simulator {inherit simulator;}) [
    "verilator"
    "wave_vpi"
    "nosim"
    # "verilator_i"
    # "verilator_dpi"
    # "vcs"
    # "vcs_dpi"
    # "xcelium"
    # "xcelium_dpi"
    # "iverilog"
  ];
}
