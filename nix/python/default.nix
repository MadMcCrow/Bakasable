# python
# the python tool we usually use
{pkgs, ...} :
let
python = pkgs.python313; 
in
{
  packages = [python];
}