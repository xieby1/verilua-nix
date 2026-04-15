let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
in pkgs.stdenv.mkDerivation rec {
  name = "wave_vpi_main";
  src = npinsed.verilua + /src/wave_vpi;
  buildInputs = [
    pkgs.fmt_11
    pkgs.argparse
    (import ./wellen_impl)
    (import ../libverilua)
  ];
  buildPhase = [
    "$CXX"
    "-std=c++20"
    "*.cpp"
    "src/control.cpp"
    "src/wave_vpi.cpp"
    "src/jit_options.cpp"
    "src/fsdb_wave_vpi.cpp"
    "src/vpi_compat_wellen.cpp"
    "-I${npinsed.verilua}/extern/boost_unordered"
    "-I./include"
    # TODO: the <verilua>/src/include/vpi_user.h <verilua>/src/include/svdpi.h is redundant, include it from verilator or other simulator.
    "-I${npinsed.verilua + /src/include}"
    "-O2 -funroll-loops -fomit-frame-pointer"
    "-lfmt"
    ''-D 'VERILUA_VERSION="${pkgs.lib.trim (builtins.readFile (npinsed.verilua + /VERSION))}"' ''
    "-lwave_vpi_wellen_impl"
    "-lverilua_wave_vpi"
    "-o" name
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${name} $out/bin/
  '';
}
