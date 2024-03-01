# godot
# we get godot from pre-built package, because it's faster :)
{pkgs, ...} :
let
godot-binary = import ./prebuilt.nix pkgs; 
in
{
  packages = [ godot-binary ];
}