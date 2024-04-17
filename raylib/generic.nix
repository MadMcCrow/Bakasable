# raylib built from sources !
{pkgs , ...} :
pkgs.raylib.overrideAttrs rec{
  version = "5.0";
  src = pkgs.fetchFromGitHub {
    owner = "raysan5";
    repo = "raylib";
    rev = "${version}";
    hash = "sha256-gEstNs3huQ1uikVXOW4uoYnIDr5l8O9jgZRTX1mkRww=";
  };
  patches = [
    # TODO : keep a local version for when we update !
    (pkgs.fetchpatch {
      url = "https://github.com/raysan5/raylib/commit/032cc497ca5aaca862dc926a93c2a45ed8017737.patch";
      hash = "sha256-qsX5AwyQaGoRsbdszOO7tUF9dR+AkEFi4ebNkBVHNEY=";
    })
  ];

}

