# Fast, simple Godot for nix
{pkgs, ... } :
let
prebuilds = import ./prebuilds.nix pkgs;
in
{
  packages = with prebuilds; [stable beta];
}
