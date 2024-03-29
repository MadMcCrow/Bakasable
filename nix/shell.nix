# shell environment to develop
{ pkgs, ... }:
let

  modules = [./godot ./python];

  # rust is required for commit hooks :
  rust = [ pkgs.rustup ];

in
pkgs.mkShell { 
  # let's have everything to work
  buildInputs = rust ++ (pkgs.lib.lists.flatten 
  (map (x : (import x {inherit pkgs;}).packages) modules));
}
