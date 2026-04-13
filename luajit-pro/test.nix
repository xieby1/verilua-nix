let
  npinsed = import ../npins;
  pkgs = import npinsed.nixpkgs {};
  luajit-pro = import ./.;
  out = luajit-pro.outPath;
in pkgs.lib.runTests {
  test-output-structure = pkgs.lib.testAllTrue [
    ((builtins.readDir out) ? "bin")
    ((builtins.readDir (out + "/lib")) ? "libluajit-5.1.so")
    ((builtins.readDir (out + "/lib")) ? "libluajit-5.1.a")
    ((builtins.readDir (out + "/lib")) ? "pkgconfig")
    ((builtins.readDir (out + "/include")) ? "lua.h")
  ];
  test-executable = {
    expr = builtins.readFile (pkgs.runCommand "test-luajit-executable" {
      nativeBuildInputs = [ luajit-pro ];
    } ''
      ${luajit-pro}/bin/lua -e 'print("Hello World")' > $out
    '');
    expected = "Hello World\n";
  };
}
