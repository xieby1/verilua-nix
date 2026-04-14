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
  npinsed = import <npins>;
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

# Using `<npins>` and `<luajit-pro>` in NIX_PATH

The `<npins>` and `<luajit-pro>` syntax works because `shell.nix` exports `NIX_PATH=npins=$(realpath ./npins/):luajit-pro=$(realpath ./luajit-pro/)` in its `shellHook`.

**Requirements:**
- Use `nix-shell`, `nix develop`, or direnv to ensure `NIX_PATH` is set

# Common Patterns

- Use `builtins.readDir` to explore directory structure
- Use `pkgs.lib.filterAttrs (_: v: v != null)` to drop unset optional fields
- Use `pkgs.lib.mkIf` to conditionally apply config
- Use `builtins.tryEval` to test code that should fail
- When importing `default.nix`, use `import ./.` instead of `import ./default.nix`

## Testing derivations/packages

**Before writing tests, always build the derivation first:**

```bash
nix-build <path-to-default.nix> -o result-tmp
# Explore subdirectories to find actual output files
```

This reveals:
- What files/directories the derivation produces
- The exact path structure to test

**Then write tests for actual user-facing files:** C libs (`.so`, `.a`) and Lua scripts (`.lua`)

Do **not** write trivial attribute tests (e.g. `version`, `src`, `pname`)
Do **not** write trivial folder existence tests (e.g. test whether folder `lib/`, `bin/`, `lua/` exists)

## Testing library output

For single files, use `builtins.pathExists` which is simpler than `builtins.readDir`:

```nix
test-libs = pkgs.lib.testAllTrue [
  (builtins.pathExists (import ./. + /lib/libfoo.so))
];
```

## Testing executables

Simple existence test:
```nix
test-executable = pkgs.lib.testAllTrue [
  (builtins.pathExists (my-derivation + /bin/myexe))
];
```

Run executable and verify output:
```nix
test-executable-runs = let
  output = pkgs.runCommand "test-myexe" {
    env = {
      MY_ENV_VAR = toString npinsed.some-path;
    };
  } ''
    ${my-derivation}/bin/myexe --help > $out 2>&1 || true
  '';
  content = builtins.readFile output;
in pkgs.lib.testAllTrue [
  (builtins.stringLength content > 100)
  (pkgs.lib.hasPrefix "<some-pattern>" content)
];
```

**Notes:**
- Use `env` attribute to set environment variables required by the executable
- `env` values must be derivations, strings, booleans, or integers — use `toString` for paths
- Redirect stderr to stdout (`2>&1`) to capture all output
- Use `|| true` if the executable may return non-zero exit code (e.g., `--help` often does)
- Check for representative content (prefix, length) rather than exact match
- Use `builtins.stringLength` (not `pkgs.stringWidth`) to check string length

## pkgs.lib.testAllTrue

Combine all tests expecting `true` into a single `pkgs.lib.testAllTrue`:

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
```

# Naming Conventions

- Use `npinsed` for the npins attribute set to distinguish from `pkgs.npins`
- Use `pkgs` for the nixpkgs instance derived from npinsed

# References

- `nixpkgs` (or `pkgs`) source code: `$(nix eval --impure --expr "(import $NPINS_DIRECTORY).nixpkgs.outPath")`
