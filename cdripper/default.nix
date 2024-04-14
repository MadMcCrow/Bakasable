{ pkgs, ... }:
let
  # read config file provided
  config = ./config;
  # write app
in pkgs.writeShellApplication {
  name = "cdripper";

  runtimeInputs = with pkgs; [ hwinfo cdrdao flac rubyripper ];

  # TODO :
  # customise config based on hardware 
  # replace by a progressbar (wrap in python ?)
  text = ''
    DEVICE=$(hwinfo --cdrom | sed -Ern 's/.*Device:.*"([A-Z0-9\-]*)"/\1/gp')
    echo "extracting disk in $DEVICE"
    ${pkgs.rubyripper}/bin/rrip_cli --file ${config} -B -d 
    eject
  '';
}
