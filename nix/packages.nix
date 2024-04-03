# shell environment to develop
{ pkgs, ... } @args :
let
  modules = [./godot ./python];

  allPackages = (pkgs.lib.lists.flatten 
    (map (x : (import x args).packages) modules));

in builtins.listToAttrs (map (x : {name = "${pkgs.lib.getName x}"; value = x;}) allPackages) 
    
