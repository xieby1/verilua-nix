let
  npinsed = import ./npins;
  pkgs = import npinsed.nixpkgs {};
  my-derivation = import ./.;
  envs-content = builtins.readFile (my-derivation + /envs);
  propagated-content = builtins.readFile (my-derivation + /nix-support/propagated-build-inputs);
in pkgs.lib.runTests {
  test-envs = pkgs.lib.testAllTrue [
    (builtins.pathExists (my-derivation + /envs))
    (pkgs.lib.hasPrefix "export VERILUA_HOME=" envs-content)
    (pkgs.lib.hasInfix "export LUA_PATH=" envs-content)
    (pkgs.lib.hasInfix "export LUA_CPATH=" envs-content)
  ];
  test-propagated-build-inputs = pkgs.lib.testAllTrue [
    (pkgs.lib.hasInfix "xmake-verilua-flavored" propagated-content)
    (pkgs.lib.hasInfix "luajit" propagated-content)
    (pkgs.lib.hasInfix "libverilua" propagated-content)
    (pkgs.lib.hasInfix "wave_vpi" propagated-content)
  ];
}
