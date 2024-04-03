# flake.nix
{
  description = ''
  BAKA-SABLE is a pun on bac-a-sable (sandbox in french) and Baka (fool in japanese)
  It's a collection of WIP stuff I make in nix and what not
  '';

  # flake inputs :
  inputs = {
    # nixpkgs :
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pycnix.url  = "github:MadMcCrow/pycnix";
    pycnix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, pycnix, ... }:
    let
      # multiplatform support
      # only tested on x86_64 linux
      systems = [
        "x86_64-linux"
        "aarch64-linux" # <- not tested
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems f;

      # import functions:
      imp = module: system: (import module {
        inherit pycnix;
        flake = self;
        pkgs = import nixpkgs { inherit system; };
        lib = nixpkgs.lib;
      });

    in
    {
      packages = forAllSystems (system: imp ./nix/packages.nix system);

      # checks for remote compilation
      # TODO : setup checks
      # checks = forAllSystems (system: { demo = demo system; });

      # shell for development
      # TODO : macOS development
      devShells = forAllSystems (system: {
        default = imp ./nix/shell.nix system;
      });
    };
}
