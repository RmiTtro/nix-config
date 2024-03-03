{ pkgs ? import <nixpkgs> { } }: rec {

  # Personal scripts
  mywikiserver = pkgs.callPackage ./mywikiserver { }; 
  clipboard = pkgs.callPackage ./clipboard { };
}
