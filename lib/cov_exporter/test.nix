let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  my-derivation = import ./.;
in pkgs.lib.runTests {
  test-executable-exists = pkgs.lib.testAllTrue [
    (builtins.pathExists (my-derivation + /bin/cov_exporter))
  ];

  test-executable-runs = let
    output = pkgs.runCommand "test-cov_exporter-runs" {
    } ''
      ${my-derivation}/bin/cov_exporter --help > $out 2>&1 || true
    '';
    content = builtins.readFile output;
  in pkgs.lib.testAllTrue [
    (builtins.stringLength content > 100)
    (pkgs.lib.hasInfix "OVERVIEW: cov_exporter" content)
  ];
}
