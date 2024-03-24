# python
# the python tool we usually use
{pkgs, ...} :
let
# python version to use
python = pkgs.python311; 

# submodules
modules = [ ./dvdrip.nix ];

# import all our scripts/app/etc
customPackages = map (x : import x {inherit python pkgs;}) modules;
in
{
  packages = [ python ] ++ customPackages;
}