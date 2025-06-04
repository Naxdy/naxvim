{
  description = "Naxdy's Neovim configuration using nixvim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sscli = {
      url = "github:Naxdy/sscli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      sscli,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                self.overlays.default
              ];
            };
          in
          f {
            inherit system pkgs;
          }
        );
    in
    {
      packages = forEachSupportedSystem (
        { pkgs, system, ... }:
        {
          default = self.packages.${system}.naxvim;

          naxvim = pkgs.naxvim;
        }
      );

      overlays.default = self.overlays.naxvim;

      overlays.naxvim =
        final: prev:
        (
          {
            naxvim = final.callPackage ./package.nix {
              sscli = sscli.packages.${final.system}.default;
            };
          }
          // (nixvim.overlays.default final prev)
        );
    };
}
