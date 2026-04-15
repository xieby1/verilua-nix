let
  npinsed = import ../../../npins;
  pkgs = import npinsed.nixpkgs {};
  my-derivation = import ./.;
in pkgs.lib.runTests {
  test-lib = pkgs.lib.testAllTrue [
    (builtins.pathExists (my-derivation + /lib/libwave_vpi_wellen_impl.so))
  ];
}
