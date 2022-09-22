{
  nixpkgs-ruby ? import (fetchTarball "https://github.com/juanibiapina/nixpkgs-ruby/archive/main.tar.gz"),
  pkgs ? import <nixpkgs> { overlays = [ nixpkgs-ruby ]; },
}:

let
  ruby_package = pkgs.parseRubyVersionFile {};
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    pkgs.${ruby_package}
    firefox-bin
    geckodriver
  ];
  shellHook = ''
    # install gems locally
    mkdir -p .local/nix-gems
    export GEM_HOME=$PWD/.local/nix-gems
    export GEM_PATH=$GEM_HOME
    export PATH=$GEM_HOME/bin:$PATH

    # add local bin directory to path
    export PATH=$PWD/bin:$PATH
  '';
}
