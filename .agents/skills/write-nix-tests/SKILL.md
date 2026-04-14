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

- Do **not** write trivial attribute tests (e.g. `version`, `src`, `pname`)
- Build the derivation with `nix-build <path>` first to explore output
- Test **actual user-facing files**: C libs (`.so`, `.a`) and Lua scripts (`.lua`)

## Testing executables

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

- `nixpkgs` source code: `$(nix eval --impure --expr "(import $NPINS_DIRECTORY).nixpkgs.outPath")`
