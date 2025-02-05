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
            self.overlays.default
          ];
        };
      in
      {
        packages = {
          default = self.packages.${system}.naxvim;

          naxvim = pkgs.naxvim;
        };
      }
    )
    // {
      overlays.default = self.overlays.naxvim;

      overlays.naxvim =
        final: prev:
        (
          {
            naxvim = final.callPackage ./package.nix { };
          }
          // (nixvim.overlays.default final prev)
        );
    };
}
