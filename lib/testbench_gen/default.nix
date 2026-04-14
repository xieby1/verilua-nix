let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
in pkgs.stdenv.mkDerivation rec {
  name = "testbench_gen";
  src = npinsed.verilua + /src/testbench_gen;
  buildInputs = [
    pkgs.inja
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
    (import <luajit-pro>)
  ];
  # TODO: use build tool? For example Makefile.
  buildPhase = [
    "$CXX"
    # TODO: redunant?
    # "-std=c99"
    "-std=c++20"
    # TODO: ./*.cpp uses std::cerr while only include iostream
    "-include iostream"
    "*.cpp" "${npinsed.slang-common}/*.cpp"
    "-DSLANG_BOOST_SINGLE_HEADER"
    "-I${npinsed.slang-common}"
    "-I${npinsed.boost_unordered}"
    "-lsvlang" "-lfmt" "-lmimalloc"
    "-lassert" "-lcpptrace"
    # "-ldwarf"
    "-lzstd" "-lz"
    "-lluajit-5.1"
    # "-lluajit_pro_helper"
    ''-D 'VERILUA_VERSION="${pkgs.lib.trim (builtins.readFile (npinsed.verilua + /VERSION))}"' ''
    "-o" name
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${name} $out/bin/
  '';
}
