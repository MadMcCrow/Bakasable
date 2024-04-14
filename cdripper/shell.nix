# Ruby ripper shell command
{ pkgs ? import <nixpkgs> { } }@args:
let myripper = import ./myrrip.nix { inherit pkgs; };
in pkgs.mkShell { buildInputs = [ myripper ]; }
