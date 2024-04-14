# Raylib 
# Gamedev Framework
{pkgs, tests} : 
let
  # raylib
  raylib-c = import ./raylib-c.nix pkgs;
  raylib-d = import ./raylib-d.nix {inherit pkgs raylib-c;};

  demo-c = raylib-c.mkRaylibCGame rec {
              name = "demo-raylib-c";
              src = "${tests}/raylib-c";
              buildInputs = [raylib-c.raylib];
              buildPhase = ''
                $CC main.c -o out.bin -lraylib
              '';
              installPhase = ''
                mkdir -p $out/bin
                cp -R ./out.bin $out/bin/${name}
              '';
            };

    # raylib-d test
    demo-d = raylib-d.mkRaylibDGame {
      name = "demo-raylib-d";
      src = "${tests}/raylib-d";
    };
in 
{
  packages = [raylib-c.raylib demo-d] ++ raylib-d.packages;
}