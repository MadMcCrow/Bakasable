# shell environment to develop
{ pkgs, lib, flake, pycnix, ... }@args:
let

  # submodules 
  modules = [ ./dvdrip ./cdripper ./python ./godot ];

  packages = [ python ] ++ (map (x:
    let mod = import x args;
    in if mod ? "packages" then mod.packages else [ mod ]) modules);

in builtins.listToAttrs (map (x: {
  name = "${pkgs.lib.getName x}";
  value = x;
}) packages)

