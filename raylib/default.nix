# Raylib 
# Gamedev Framework
{pkgs, ...} : 
let
  # raylib
  raylib = pkgs.callPackage ./generic.nix {};
  demo = pkgs.runCommandCC "raylib-demo"
    rec {
      buildInputs = [raylib];
      meta.mainProgram = "demo";
    } ''
    mkdir -p "$out/bin"
    $CC -std=c11 -Wall -pedantic -lraylib ${./demo.c} \
    -o "$out/bin/demo";
    '';
in 
{
 packages = [demo];
}