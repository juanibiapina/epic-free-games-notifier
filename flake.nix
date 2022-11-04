{
  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nixpkgs = {
      url = "nixpkgs";
    };
    nixpkgs-ruby = {
      url = "github:juanibiapina/nixpkgs-ruby";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nixpkgs-ruby }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            overlays = [ nixpkgs-ruby.overlays.default ];
            inherit system;
          };
        in
        {
          devShells.default = import ./shell.nix { inherit pkgs; };
        }
      );
}
