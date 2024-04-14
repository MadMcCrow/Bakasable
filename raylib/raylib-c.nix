# Raylib from github pre-builds
# TODO:
#   - Add Web-assembly pre-build
pkgs :
let
# no need for compiler to package
stdenv = pkgs.stdenvNoCC;

# base URL for download
releaseURL = "https://github.com/raysan5/raylib/releases/download";

# generic install version
generic_base = {version, src, ...} @args : stdenv.mkDerivation  (args //{
  inherit src;
  pname = "raylib";
  name = "raylib-${version}";
  # install library to lib folder
  installPhase = ''
  mkdir -p $out
  cp -r lib $out/
  cp -r include $out/
  export RAYLIB_C_PATH=$out
  ''
  + (args.installPhase or "");
    meta = pkgs.raylib.meta // {
    platforms = [pkgs.system];
  };
 });

generic_darwin = {version, sha } : generic_base {
  inherit version;
  src = pkgs.fetchzip {
      hash = sha;
      url = "${releaseURL}/${version}/raylib-${version}_macos.tar.gz";
    };
};
generic_linux = {version, sha } : generic_base {
  inherit version;
  src = pkgs.fetchzip {
      hash = sha;
      url = "${releaseURL}/${version}/raylib-${version}_linux_amd64.tar.gz";
    };
};
  generic = {version, shaLinux, shaDarwin} : if stdenv.isDarwin then 
  generic_darwin {inherit version; sha = shaDarwin;} else if 
  stdenv.isLinux then generic_linux {inherit version; sha = shaLinux;}
  else throw "unsupported platform ${pkgs.platform}";

in rec {
  raylib = generic {
    version = "4.5.0";
    shaDarwin = "sha256-SFkoWKOjqOmdhuCuJhaE1GZ2hOfeA6Lgb4t07tCp/f8=";
    shaLinux = "";
  };

  mkRaylibCGame = {src, name, ...} @args : pkgs.stdenv.mkDerivation (args //{
      inherit name src;
      buildInputs = (args.buildInputs or []) ++ [raylib];
      fixupPhase = ''
                install_name_tool -add_rpath ${raylib}/lib $out/bin/${name}
      '';
  });
}

