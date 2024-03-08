# godot
# we get godot from pre-built package, because it's faster :)
# TODO : export templates :
pkgs :
let
stdenv = pkgs.stdenvNoCC;

# default builder
generic = { version, platform, hash } : stdenv.mkDerivation {
  name = "godot";
  inherit version;
  src = pkgs.fetchzip {
    url = "https://github.com/godotengine/godot/releases/download/${version}/Godot_v${version}_${platform}.zip";
    inherit hash;
    };

  installPhase = ''
  runHook preInstall
  install -m755 -D  ./Godot_v${version}_${platform} $out/bin/godot
  runHook postInstall
  '';
   meta = {
      homepage = pkgs.godot_4.meta.homepage;
      platforms = pkgs.lib.platforms.all;
      mainProgram = "godot";
    };
};

generic-linux = args : (generic args).overrideAttrs {
  nativeBuildInputs = [
    pkgs.autoPatchelfHook
  ];
  # maybe too much, who knows
  runtimeDependencies = with pkgs; [
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXext
    xorg.libXfixes
    vulkan-loader 
    vulkan-headers 
    vulkan-tools 
    glslang
    libGLU
    libGL
    udev
    systemd
    systemd.dev
    libpulseaudio
    freetype
    openssl
    alsa-lib
    fontconfig.lib
    speechd
    libxkbcommon
    dbus.lib
    ];
};

# TODO :
export = "https://github.com/godotengine/godot/releases/download/4.2.1-stable/Godot_v4.2.1-stable_export_templates.tpz";

# select binary
in if stdenv.isDarwin then generic {
  version = "4.1.3-stable";
  platform = "macos.universal";
  hash = "sha256-dwZ6q8bktAYBOqx4k6SuIhq17Qx5clnORjqpXPRdc8Q=";
} 
else if (stdenv.isLinux && stdenv.isx86_64) then 
generic-linux
{
  version = "4.2.1-stable";
  platform = "linux.x86_64";
  hash = "sha256-dHlwkS2JHgLiXFPncLbSjZ7JqfcySS6k1pYPOyY59yk=";
} 
else if (stdenv.isLinux && stdenv.isAarch64) then 
generic-linux
{
  version = "4.2.1-stable";
  platform = "linux.arm64";
  hash = "";
}
else throw "please add your platform for Godot"
