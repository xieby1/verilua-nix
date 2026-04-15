let
  npinsed = import ../../npins;
  pkgs = import npinsed.nixpkgs {};
in pkgs.rustPlatform.buildRustPackage (finalAttrs: {
  name = "luajit-pro-help";
  src = npinsed.verilua + /luajit-pro;
  cargoLock = {
    lockFile = npinsed.verilua + /luajit-pro/Cargo.lock;
    outputHashes = {
      "darklua-0.16.0" = "sha256-UC1nZ7nqJawqGlZYzSzVds47SUYmN9NwfohuYuHVKzQ=";
    };
  };
})
