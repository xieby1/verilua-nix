let
  npinsed = import ./npins;
  pkgs = import npinsed.nixpkgs {};
  my-derivation = import ./.;
  propagated-content = builtins.readFile (my-derivation + /nix-support/propagated-build-inputs);
in pkgs.lib.runTests {
  test-shellHook = pkgs.lib.testAllTrue [
    (pkgs.lib.hasPrefix "export VERILUA_HOME=" my-derivation.shellHook)
    (pkgs.lib.hasInfix "export LUA_PATH=" my-derivation.shellHook)
    (pkgs.lib.hasInfix "export LUA_CPATH=" my-derivation.shellHook)
  ];
  test-propagated-build-inputs = pkgs.lib.testAllTrue [
    (pkgs.lib.hasInfix "xmake-verilua-flavored" propagated-content)
    (pkgs.lib.hasInfix "luajit" propagated-content)
    (pkgs.lib.hasInfix "libverilua" propagated-content)
    (pkgs.lib.hasInfix "wave_vpi" propagated-content)
  ];
}
