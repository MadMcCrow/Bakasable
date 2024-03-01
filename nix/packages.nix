# shell environment to develop
{ pkgs, ... }:
let
  modules = [./godot ./python];

  allPackages = (pkgs.lib.lists.flatten 
    (map (x : (import x {inherit pkgs;}).packages) modules));

in builtins.listToAttrs (map (x : {name = "${pkgs.lib.getName x}"; value = x;}) allPackages) 
    
