let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  my-derivation = import ./.;
in pkgs.lib.runTests {
  test-executable-exists = pkgs.lib.testAllTrue [
    (builtins.pathExists (my-derivation + /bin/wave_vpi_main))
  ];

  test-executable-runs = let
    output = pkgs.runCommand "test-wave_vpi_main-runs" {
    } ''
      ${my-derivation}/bin/wave_vpi_main --help > $out 2>&1 || true
    '';
    content = builtins.readFile output;
  in pkgs.lib.testAllTrue [
    (builtins.stringLength content > 50)
    (pkgs.lib.hasInfix "Usage:" content)
  ];
}
