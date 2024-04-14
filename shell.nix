# shell environment to develop
{ pkgs, lib, flake, pycnix, ... }@args:
let
packages = import ./packages.nix args;
in
pkgs.mkShell {
  buildInputs = map (x : (if x ? "buildInputs" then x.buildInputs else []) ++ (if x ? "nativeBuildInputs" then x.nativeBuildInputs else [])) (builtins.getValues packages);
}