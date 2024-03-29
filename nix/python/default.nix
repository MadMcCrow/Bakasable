# python
# the python tool we usually use
{pkgs, flake, ...} @args :
let
# python version to use
python = pkgs.python311; 

# submodules
modules = [ ./dvdrip.nix ./pyupscaler.nix ];

# import all our scripts/app/etc
customPackages = map (x : import x args) modules;
in
{
  packages = [ python ] ++ customPackages;
}