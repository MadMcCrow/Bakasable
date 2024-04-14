{ pkgs, ... }:
let
  # python version to use
  python = pkgs.python311;
  modules = [ ./ffpy ./pyrip ./pyupscaler ];
in { packages = []; }
