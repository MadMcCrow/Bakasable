# python
# the python tool we usually use
{pkgs, lib, flake, pycnix, ...} @args :
let
# python version to use
python = pkgs.python311; 
# submodules 
modules =  [ ./dvdrip.nix ];
in
{
  packages = [ python ] 
  ++ (map (x : import x (args // { inherit python;})) modules);
}