let
  npinsed = import ./npins;
  pkgs = import npinsed.nixpkgs {};
in pkgs.mkShell {
  name = "verilua-nix";
  packages = [
    pkgs.npins
    # Dolt >= v1.81.10 supports git remotes.
    # The version in nixpkgs 25.11 too old,
    # so we use dolt from nixpkgs-unstable instead.
    # See: https://www.dolthub.com/blog/2026-02-13-announcing-git-remote-support-in-dolt/
    (import npinsed.nixpkgs-unstable {}).dolt
    # For CI plot dolt statistics
    (pkgs.python3.withPackages (pyPkgs: [
      pyPkgs.plotly
    ]))
  ];
}
