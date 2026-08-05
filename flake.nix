{
  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        flake-parts-lib,
        self,
        withSystem,
        ...
      }:
      {
        systems = import inputs.systems;

        flake.nixosModules =
          let
            peer-ban-helper = {
              imports = [ (flake-parts-lib.importApply "${self}/modules/nixos" { inherit withSystem; }) ];
            };
          in
          {
            inherit peer-ban-helper;
            default = peer-ban-helper;
          };

        perSystem = { pkgs, ... }: {
          packages =
            let
              peer-ban-helper-bin = pkgs.callPackage ./packages/peer-ban-helper-bin { };
            in
            {
              inherit peer-ban-helper-bin;
              default = peer-ban-helper-bin;
            };
        };
      }
    );
}
