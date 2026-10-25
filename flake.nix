{
  description = "libmpv-darwin-build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { flakelight, ... }:
    flakelight ./. {
      flakelight.builtinFormatters = false;
      withOverlays = import ./nix/utils/default/overlays.nix;
      nixpkgs.config = {
        allowUnfree = true;
      };
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      devShell = pkgs: {
        stdenv = pkgs.stdenvNoCC;
        packages = with pkgs; [
          tree
          gnumake
          # real git so the Makefile trap works: /usr/bin/git is an Apple shim
          # that resolves through xcrun, which hits the broken xcbuild xcrun
          # shim that the environment puts earlier on PATH
          git
        ];
      };
      perSystem =
        { pkgs, ... }:
        {
          packages = import ./nix/utils/flake/create-cross-packages.nix {
            inherit pkgs;
            path = ./nix/packages;
          };
        };
    };
}
