let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  signal_db_gen = import ./.;
in pkgs.lib.runTests {
  test-executable = pkgs.lib.testAllTrue [
    (builtins.pathExists (signal_db_gen + /bin/signal_db_gen))
  ];

  test-lib = pkgs.lib.testAllTrue [
    (builtins.pathExists (signal_db_gen + /lib/libsignal_db_gen.so))
  ];

  test-executable-runs = let
    output = pkgs.runCommand "test-signal_db_gen" {
      env = {
        VERILUA_HOME = toString npinsed.verilua;
      };
    } ''
      ${signal_db_gen}/bin/signal_db_gen --help > $out 2>&1 || true
    '';
    content = builtins.readFile output;
  in pkgs.lib.testAllTrue [
    (builtins.stringLength content > 100)
    (pkgs.lib.hasPrefix "OVERVIEW: signal_db_gen" content)
  ];
}
