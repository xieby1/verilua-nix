let
  npinsed = import ../../npins;
  pkgs = import npinsed.nixpkgs {};
in pkgs.stdenv.mkDerivation {
  name = "signal_db_gen";
  src = npinsed.verilua + /src/signal_db_gen;
  buildInputs = [
    pkgs.sol2
    pkgs.nlohmann_json
    (import ../slang {})
    pkgs.fmt_11
    (import ../mimalloc2)
    (import ../libassert)
    pkgs.cpptrace
    pkgs.zstd
    pkgs.libz
    # TODO: Does this luajit-pro needs withPackages?
    (import ../../luajit-pro)
  ];
  buildPhase = let
    cxx_common_cmd = [
      "$CXX"
      # TODO: redunant?
      # "-std=c99"
      "-std=c++20"
      # ignal_db_gen.cpp uses std::cerr but not include iostream
      "-include iostream"
      "*.cpp"
      "${npinsed.verilua}/extern/slang-common/*.cpp"
      "-DSLANG_BOOST_SINGLE_HEADER"
      "-I${npinsed.verilua}/extern/slang-common"
      "-I${npinsed.verilua}/extern/boost_unordered"
      # TODO: <libs_dir>/include
      # TODO: <lua_dir>/include/luajit-2.1
      "-lsvlang" "-lfmt" "-lmimalloc"
      "-lassert" "-lcpptrace"
      # "-ldwarf"
      "-lzstd" "-lz"
      "-lluajit-5.1"
      # "-lluajit_pro_helper"
      ''-D 'VERILUA_VERSION="${pkgs.lib.trim (builtins.readFile (npinsed.verilua + /VERSION))}"' ''
    ];
  # TODO: use build tool? For example Makefile.
  in ''
    ${toString cxx_common_cmd} -o signal_db_gen
    ${toString cxx_common_cmd} -DSO_LIB -shared -o libsignal_db_gen.so
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp signal_db_gen $out/bin/
    mkdir -p $out/lib
    cp libsignal_db_gen.so $out/lib
  '';
}
