{ pkgs }:

let
  inherit (pkgs) nixpkgs;
  lib = nixpkgs.lib;

in nixpkgs.dockerTools.buildImage {
  name = "test";
  tag = "dockerTools";

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
