let
  npinsed = import ../../npins;
  pkgs = import npinsed.nixpkgs {};
  slang = import ./default.nix {};
in pkgs.lib.runTests {
  test-structure = pkgs.lib.testAllTrue [
    (builtins.pathExists (slang + "/lib/libsvlang.a"))
    (builtins.pathExists (slang + "/include/slang"))
    (builtins.pathExists (slang + "/share/pkgconfig/sv-lang.pc"))
    (pkgs.lib.hasInfix "sv-lang" (builtins.readFile (slang + "/share/pkgconfig/sv-lang.pc")))
  ];
}
