let
  npinsed = import ../../npins;
  pkgs = import npinsed.nixpkgs {};
in pkgs.mimalloc.overrideAttrs (old: {
  version = npinsed.mimalloc2.version;
  src = npinsed.mimalloc2;
})
