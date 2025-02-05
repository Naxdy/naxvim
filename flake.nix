{
  description = "Naxdy's Neovim configuration using nixvim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nixvim,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            nixvim.overlays.default
          ];
        };
      in
      {
        packages = {
          default = self.packages.${system}.naxvim;

          naxvim = pkgs.callPackage ./package.nix { };
        };
      }
    );
}
