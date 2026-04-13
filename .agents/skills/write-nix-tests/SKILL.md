---
name: write-nix-tests
description: Write tests for nix scripts. Use when creating or modifying nix scripts, or generating test.nix files.
---

# File Structure

A nix script lives in a directory with:

```
nix-script-name/
├── default.nix   # Main nix script
├── test.nix      # Tests using pkgs.lib.runTests
```

# Test Template

Tests use `nix eval -f test.nix` — success when output is `[ ]` (empty list).

```nix
let
  npinsed = import ../../npins;
  pkgs = import npinsed.nixpkgs {};
  my-derivation = import ./.;
in pkgs.lib.runTests {
  test-name = {
    expr = <expression>;
    expected = <expected value>;
  };
}
```

Run tests with: `nix eval -f test.nix`

# Common Patterns

- Use `builtins.readDir` to explore the directory structure of the given path or package
- Use `pkgs.lib.filterAttrs (_: v: v != null)` to drop unset optional fields before serialization
- Use `pkgs.lib.types.either pkgs.lib.types.str (pkgs.lib.types.listOf pkgs.lib.types.str)` for fields accepting one or many strings
- Use `pkgs.lib.mkIf` to conditionally apply config only when the option is non-empty
- Use `pkgs.lib.hasInfix` to check if a string contains a substring
- Use `builtins.tryEval` to test code that should fail (e.g., assertion failures)
- Declare variables in the narrowest scope needed — avoid top-level declarations when only used in one test
- When importing a `default.nix` file, omit the filename: use `import ./.` instead of `import ./default.nix`

## Testing derivations/packages

- Do **not** write trivial attribute tests (e.g. `version`, `src`, `pname`) for derivations — these add no value
- Instead, build the derivation with `nix-build <path>` first to explore its output, then write tests that check the directory structure of the built result using `builtins.readDir`
- Only test files that are meaningful to users of the package (e.g. the static and shared libraries for a C library, not intermediate build artifacts like `.o` files)

## Testing Lua packages (buildLuarocksPackage)

Lua packages using `buildLuarocksPackage` are functions that take parameters, so they cannot be built with direct `nix-build`. `nix-build` can only build files that contain a derivation. For nix files that contain a function returning a derivation, you need to evaluate that function explicitly.

**Building Lua packages for inspection:**

```bash
nix build --expr "let luajit-pro = import ./luajit-pro; in luajit-pro.pkgs.callPackage ./luajit-pro/lua/<package> {}"
```

This evaluates the function and builds the resulting derivation, allowing you to inspect its output structure.

**Critical distinction:**
- `pkgs.callPackage` — uses packages defined in nixpkgs (e.g., `pkgs.luacov`)
- `luajit-pro.pkgs.callPackage` — uses packages specific to luajit-pro

This ensures dependencies (like `luacov`) come from luajit-pro's packages.

```nix
let
  npinsed = import <npins-path>;
  pkgs = import npinsed.nixpkgs {};
  luajit-pro = import <luajit-pro-path>;
  lua-package = luajit-pro.pkgs.callPackage ./. {};
  out = lua-package.outPath;
in pkgs.lib.runTests {
  test-out = pkgs.lib.testAllTrue [
    (builtins.pathExists (out + "/lib/lua/5.1/<package-name>/<c-lib>.so"))
    (builtins.pathExists (out + "/share/lua/5.1/<package-name>/<lua-script>.lua"))
  ];
}
```

Key points:
- Use `luajit-pro.pkgs.callPackage` to evaluate the package function with luajit-pro's package set
- This ensures dependencies (like `luacov`) come from luajit-pro's packages
- Test **actual user-facing files**: C libs (`.so`, `.a`) and Lua scripts (`.lua`), not directory structure
- Avoid trivial directory existence checks (e.g., checking for `share`, `5.1` directories adds no value)
- Build the package first with `nix build <expr>` to discover what files are actually installed

## Testing executables

To test whether an executable works, use `pkgs.runCommand` with `builtins.readFile` to capture and compare output:

```nix
test-executable = {
  expr = builtins.readFile (pkgs.runCommand "test-myexe" {
    nativeBuildInputs = [ my-package ];
  } ''
    ${my-package}/bin/myexe --arg value > $out
  '');
  expected = "expected output\n";
};
```

Key points:
- Use `nativeBuildInputs = [ my-package ]` to make the package available in the build environment
- Write the executable output to `$out` using redirection
- Wrap the `runCommand` in `builtins.readFile` so Nix evaluates the file content during `nix eval`
- Compare against the expected string (include trailing newline for `print`-style output)

## pkgs.lib.testAllTrue

**IMPORTANT**: Always combine all standalone test cases that expect `true` into a single `pkgs.lib.testAllTrue`. Do NOT write individual `{ expr = ...; expected = true; }` tests for boolean assertions — this creates unnecessary verbosity and fragmentation.

`pkgs.lib.testAllTrue` produces a complete `{ expr, expected }` attrset on its own — do **not** wrap it in another `{ expr = ...; expected = ...; }`:

```nix
# correct
test-lib = pkgs.lib.testAllTrue [
  (dir ? "libfoo.a")
  (dir ? "libfoo.so")
];

# wrong — double-wrapping
test-lib = {
  expr = pkgs.lib.testAllTrue [ ... ];
  expected = true;
};

# wrong — separate expected-true tests
test-libfoo = { expr = dir ? "libfoo.a"; expected = true; };
test-libfoo-so = { expr = dir ? "libfoo.so"; expected = true; };
```

**Tip**: Merge all expected-true tests into a single `pkgs.lib.testAllTrue` for cleaner test files.

# Naming Conventions

- Use `npinsed` for the npins attribute set (e.g., `import ../../npins`) to distinguish from `pkgs.npins`
- Use `pkgs` for the nixpkgs instance derived from npinsed

# References

- `nixpkgs` or `pkgs` source code: `$(nix eval --impure --expr "(import $NPINS_DIRECTORY).nixpkgs.outPath")`
