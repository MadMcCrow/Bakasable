# pyupscaler
# python tool for upscaling stuff
{ pkgs, python, flake, ... }  :
let
in
pkgs.stdenvNoCC.mkDerivation {
  name = "pyupscaler";
  version = "0.0";
  src = flake + ./python/pyupscaler;
  installPhase = ''
    mkdir -p $out/lib
    cp ./* $out/lib
  '';
}