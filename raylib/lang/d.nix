# RAYLIB with D LANG
# Support for building things in D
{pkgs, raylib-c} : let

  # version should equal raylib version
  version = "4.5.2";

  # raylib C binaries
  raylib = raylib-c.raylib;

  # D toolchain
  dlang = with pkgs; [dtools ldc dub];

  # Raylib-D
  raylib-d = pkgs.stdenvNoCC.mkDerivation {
    name = "raylib-D";
    inherit version;
    # fetch the repo from github
    src = pkgs.fetchFromGitHub {
      repo = "raylib-d";
      owner = "schveiguy";
      rev = "v${version}";
      hash = "sha256-oV769O6yw7k3VgVj3aqSSimt29PALa30OND1GPd+J7k=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r ./source $out
      cp -r ./install $out 
      cp dub.json $out
      export RAYLIB_D_PATH=$out
    '';
  };

  mkRaylibDGame = {name, src, ...} @args : pkgs.stdenv.mkDerivation (args //{
      nativeBuildInputs = (args.nativeBuildInputs or []) ++ dlang;
      buildInputs = (args.buildInputs or []) ++ [raylib-d];
      patchPhase = (args.patchPhase or "") + ''
        sed -iE 's/\"raylib-d\":.*,?/\"raylib-d\": {\"path\": "${raylib-d}\/lib"}/g' 
      '';
  });

in assert (pkgs.lib.versions.majorMinor raylib.version) == (pkgs.lib.versions.majorMinor raylib-d.version);
{
  inherit mkRaylibDGame;
  packages = dlang ++ [raylib-d] ;
}