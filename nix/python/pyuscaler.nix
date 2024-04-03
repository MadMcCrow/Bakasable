# pyupscaler
# python tool for upscaling stuff
{ pkgs, python, flake, pycnix, ... }  :
let

# TODO:
realesrgan = python.pkgs.buildPythonPackage {
  src = https://github.com/ai-forever/Real-ESRGAN
};

# TODO :
pyffmpeg =  python.pkgs.buildPythonPackage {
  src = fetchpypi { 
  };
};


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