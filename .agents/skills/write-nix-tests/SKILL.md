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
  pkgs = import <nixpkgs> {};
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

## pkgs.lib.testAllTrue

`pkgs.lib.testAllTrue` produces a complete `{ expr, expected }` attrset on its own. Use it directly as the test case value — do **not** wrap it in another `{ expr = ...; expected = ...; }`:

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

# References

- `nixpkgs` or `pkgs` source code: `$(nix eval --impure --expr "(import $NPINS_DIRECTORY).nixpkgs.outPath")`
