# list of packages in bakasable
{ pkgs, lib, flake, pycnix, ... }@args:
let

  # submodules 
  modules = [
    ./cdripper 
    ./dvdrip 
    # ./python 
    # ./godot
    ];

  packages = lib.lists.flatten (map (x:
    let mod = import x args;
    in if builtins.hasAttr "packages" mod then mod.packages else [ mod ]) modules);

in builtins.listToAttrs (map (x: {
  name = "${pkgs.lib.getName x}";
  value = x;
}) packages)

