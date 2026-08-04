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
      { lib, self, ... }:
      {
        systems = import inputs.systems;

        flake.nixosModules =
          let
            peer-ban-helper = {
              imports = [ "${self}/modules/nixos" ];
            };
          in
          {
            inherit peer-ban-helper;
            default = peer-ban-helper;
          };

        perSystem = { pkgs, ... }: {
          packages.peer-ban-helper-bin = import ./packages/peer-ban-helper-bin { inherit lib pkgs; };
        };
      }
    );
}
