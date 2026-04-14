let
  npinsed = import <npins>;
  pkgs = import npinsed.nixpkgs {};
in pkgs.rustPlatform.buildRustPackage {
  name = "libwave_vpi_wellen_impl";
  src = npinsed.verilua + /src/wave_vpi/wellen_impl;
  postPatch = ''
    cp ${npinsed.verilua + /Cargo.lock} ./Cargo.lock
    chmod +w ./Cargo.lock
  '';
  cargoLock.lockFile = npinsed.verilua + /Cargo.lock;
}
