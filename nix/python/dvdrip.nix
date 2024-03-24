# dvdrip
# python tool for reading dvds
{ pkgs, python }  :
pkgs.stdenvNoCC.mkDerivation {
  
  # dvdrip is a cool script
  name = "dvdrip";

  # no version defined
  version = "0.0";

  # sources
  src = pkgs.fetchFromGitHub {
    owner = "xenomachina";
    repo = "dvdrip";
    rev  = "ed260f6b7fc995c21b9b69e59abd772492b25804";
    hash = "";
    };

  noBuildPhase = true;

  buildInputs = [ pkgs.handbrake python python.pkgs.pprintpp ];

  installPhase = ''
  install -m755 -D  ./dvdrip.py $out/lib/dvdrip.py
  echo "${pkgs.lib.getExe pkgs.python311} $out/lib/dvdrip.py $@" >> $out/bin/dvdrip
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/xenomachina/dvdrip";
    platforms = platforms.all;
    licenses  = [ licenses.gpl3 ];
    mainProgram = "dvdrip";
  };
}
    

