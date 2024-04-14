# Godot official binaries
pkgs :
let
  # no need to compile anything
  stdenv = pkgs.stdenvNoCC;

  # where to find the releases
  releaseURL = "https://github.com/godotengine/godot-builds/releases/download";

  # generic
  generic_base = {version, src, ...} @args : stdenv.mkDerivation
  (args //{
    inherit src;
    name = "godot-bin-${version}";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      echo "open -n $out/bin/godot-bin.app --args $@" > $out/bin/godot-bin
      chmod +x $out/bin/godot-bin
      cp -r $src $out/bin/godot-bin.app
    '';
    meta = pkgs.godot_4.meta // {
      platforms = pkgs.lib.platforms.all;
    };
  });
  # linux support
  generic_linux = {version, sha} : generic_base {
    inherit version;
    src = pkgs.fetchzip {
      hash = sha;
      url = "${releaseURL}/${version}/Godot_v${version}_linux.x86_64.zip";
    };
  };
  # darwin support
  generic_darwin = {version, sha} : generic_base {
    inherit version;
    src = pkgs.fetchzip {
      hash = sha;
      url = "${releaseURL}/${version}/Godot_v${version}_macos.universal.zip";
    };
  };

  # multiplatform support
  generic = {version, shaLinux, shaDarwin} : if stdenv.isDarwin then 
  generic_darwin {inherit version; sha = shaDarwin;} else if 
  stdenv.isLinux then generic_linux {inherit version; sha = shaLinux;}
  else throw "unsupported platform ${pkgs.platform}";

in rec
{
  # stable version
  stable = generic {
    version = "4.1.3-stable";
    shaDarwin = "sha256-dwZ6q8bktAYBOqx4k6SuIhq17Qx5clnORjqpXPRdc8Q=";
    shaLinux  = "";
  };
  # latest beta
  beta = generic {
    version = "4.2-beta6";
    shaDarwin = "sha256-jNTd0LmtzY5loDTtnPCSpc2t31GWpBvggY7/1AMTqYY=";
    shaLinux = "";
  };
}