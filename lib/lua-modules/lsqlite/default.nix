let
  luaPackages = (import <luajit-pro>).pkgs;
  pkgs = import (import <npins>).nixpkgs {};
in {complete}: luaPackages.buildLuarocksPackage {
  pname = if complete then "lsqlite3complete" else "lsqlite3";
  version = "0.9.6-1";
  src = (import <npins>).lsqlite-src + "/lsqlite3_v096.zip";
  propagatedBuildInputs = [
    pkgs.sqlite.dev
  ];
  buildInputs = if complete then [pkgs.glibc] else [];
}

