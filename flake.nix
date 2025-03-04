{
  description = "Naxdy's Neovim configuration using nixvim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=release-24.11";

    flake-utils.url = "github:numtide/flake-utils";

    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
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
          let
            pkgs-stable = import nixpkgs-stable {
              system = final.hostPlatform.system;
            };
          in
          {
            naxvim = final.callPackage ./package.nix { };

            nodePackages =
              # TODO: graphql-language-service-cli is currently missing in nixos unstable
              if !(prev.nodePackages ? graphql-language-service-cli) then
                (
                  prev.nodePackages
                  // {
                    inherit (pkgs-stable.nodePackages) graphql-language-service-cli;
                  }
                )
              else
                prev.nodePackages;
          }
          // (nixvim.overlays.default final prev)
        );
    };
}
