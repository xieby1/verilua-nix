let
  npinsed = import ../../npins;
  pkgs = import npinsed.nixpkgs {};
in {
  shared ? false,
}: pkgs.stdenv.mkDerivation {
  name = "slang";
  src = npinsed.slang;
  # Remove the ${prefix}/ in scripts/sv-lang.pc.in, which is redundant in nix.
  # For more info, see https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    sed -i 's,''${prefix}/,,' scripts/sv-lang.pc.in
  '';
  nativeBuildInputs = [
    pkgs.cmake
    pkgs.python3
  ];
  buildInputs = [
    (pkgs.fmt_11.override {enableShared = shared;})
    (import ../mimalloc2)
  ];
  cmakeFlags = [
    "-DSLANG_INCLUDE_TOOLS=OFF"
    "-DSLANG_INCLUDE_TESTS=OFF"
    "-DSLANG_USE_MIMALLOC=ON"
    ''-DBUILD_SHARED_LIBS=${if shared then "ON" else "OFF"}''
  ];
}
