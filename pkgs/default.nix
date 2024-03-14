{ pkgs ? import <nixpkgs> { } }: rec {

  # Personal scripts
  mywikiserver = pkgs.callPackage ./mywikiserver { }; 
  clipboard = pkgs.callPackage ./clipboard { };
  
  # Package that I have to commit to nixpkgs
  megashellextnemo = pkgs.libsForQt5.callPackage ./megashellextnemo {};
}
