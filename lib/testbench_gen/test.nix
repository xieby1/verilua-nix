let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  my-derivation = import ./.;
in pkgs.lib.runTests {
  test-executable-exists = pkgs.lib.testAllTrue [
    (builtins.pathExists (my-derivation + /bin/testbench_gen))
  ];

  test-executable-runs = let
    output = pkgs.runCommand "test-testbench_gen-runs" {
    } ''
      ${my-derivation}/bin/testbench_gen --help > $out 2>&1 || true
    '';
    content = builtins.readFile output;
  in pkgs.lib.testAllTrue [
    (builtins.stringLength content > 100)
    (pkgs.lib.hasPrefix "OVERVIEW: testbench_gen" content)
  ];
}
