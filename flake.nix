{
  description = "Demonstration of nix2container's AWS Lambda incompatibility bug";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    utils.url = github:numtide/flake-utils;

    nix2container.url = github:nlewo/nix2container;
  };

  outputs = inputs@{self, utils, ...}:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = {
          nixpkgs = import inputs.nixpkgs {
            inherit system;
          };

          nix2container = inputs.nix2container.packages.${system};
        };

        lib = pkgs.nixpkgs.lib;
        stdenv = pkgs.nixpkgs.stdenvNoCC;
        mkShell = pkgs.nixpkgs.mkShell.override { inherit stdenv; };

        packages = rec {
          default = n2c;
          n2c = import ./src/n2c.nix { inherit pkgs; };
          dockerTools = import ./src/dockerTools.nix { inherit pkgs; };
        };

      in {
        inherit packages;

        devShells.default = mkShell {
          packages = with pkgs.nixpkgs; [
            aws-lambda-rie
            awscli2
            skopeo
            terraform
          ];

          shellHook = ''
            export PATH=$PWD/util:$PATH
            export AWS_CONFIG_FILE=$PWD/.aws/config
            export AWS_SHARED_CREDENTIALS_FILE=$PWD/.aws/credentials
          '';
        };
      }
    );
}
