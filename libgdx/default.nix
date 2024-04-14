# libGDX experiments in nix
{pkgs, ...} :
let

  # The setup tool
  gdx-setup = pkgs.stdenvNoCC.mkDerivation {
    name = "gdx-setup";
    version = "nightly";
    noBuildPhase = true;
    nativeBuildInputs = [pkgs.curl pkgs.cacert];
    buildInputs = with pkgs;[
      android-tools
      gradle
      jdk17
    ];
    unpackPhase = ''
      curl -O https://libgdx-nightlies.s3.amazonaws.com/libgdx-runnables/gdx-setup.jar
    '';
    installPhase = ''
    mkdir -p $out/lib $out/bin
    cp ./gdx-setup.jar $out/lib/gdx-setup.jar
    echo "java -jar $out/lib/gdx-setup.jar \$\@ --sdkLocation ${pkgs.android-tools}/bin" > $out/bin/gdx-setup
    chmod +x $out/bin/gdx-setup
    '';
  };
in
{
  packages = [gdx-setup];
  inherit gdx-setup;
}
