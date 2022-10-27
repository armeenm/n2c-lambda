{ pkgs }:

let
  inherit (pkgs) nixpkgs;
  lib = nixpkgs.lib;

  nix2container = pkgs.nix2container.nix2container;

in nix2container.buildImage {
  name = "test";
  tag = "n2c";

  copyToRoot = [
    (nixpkgs.buildEnv {
      name = "hello";
      paths = [ nixpkgs.hello ];
    })
  ];

  config = {
    entrypoint = [ "/bin/hello" ];
  };
}
