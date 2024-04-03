# dvdrip
# python tool for reading dvds
{ pkgs, python, pycnix, ... }  :
pycnix.lib."${pkgs.system}".mkCythonBin {
  inherit python;
  name = "dvdrip";
  main = "dvdrip.py";
  # no version defined
  version = "0.0";
  # sources
  src = pkgs.fetchFromGitHub {
    owner = "xenomachina";
    repo = "dvdrip";
    rev  = "ed260f6b7fc995c21b9b69e59abd772492b25804";
    hash = "sha256-LtXP1mlFgoi1JE1hKVObj4ewfZLNF0S5ej9zjeRcwCA=";
    };

    unpackPhase = ''
      cp -r $src/* ./
    '';

  buildInputs = [ pkgs.handbrake python python.pkgs.pprintpp ];

  meta = with pkgs.lib; {
    homepage = "https://github.com/xenomachina/dvdrip";
    platforms = platforms.all;
    licenses  = [ licenses.gpl3 ];
  };
}
    

