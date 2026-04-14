let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
  my-derivation = import ./.;
in pkgs.lib.runTests {
  test-executable-exists = pkgs.lib.testAllTrue [
    (builtins.pathExists (my-derivation + /bin/xmake))
    (builtins.pathExists (my-derivation + /bin/xrepo))
  ];

  test-executable-runs = let
    output = pkgs.runCommand "test-xmake-runs" {
    } ''
      ${my-derivation}/bin/xmake --version > $out 2>&1 || true
    '';
    content = builtins.readFile output;
  in pkgs.lib.testAllTrue [
    (builtins.stringLength content > 50)
    (pkgs.lib.hasInfix "xmake v3" content)
  ];

  test-verilua-rules = pkgs.lib.testAllTrue [
    (builtins.pathExists (my-derivation + /share/xmake/rules/verilua/xmake.lua))
  ];

  test-verilua-toolchains = let
    verilua_toolchains = [
      "verilator"
      "vcs"
      "xcelium"
      "wave_vpi"
    ];
    check-toolchain = tc:
      builtins.pathExists (my-derivation + /share/xmake/toolchains/${tc});
  in pkgs.lib.testAllTrue (map check-toolchain verilua_toolchains);
}
