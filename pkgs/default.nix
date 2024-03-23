{ pkgs ? import <nixpkgs> { } }: rec {

  # Personal scripts
  mywikiserver = pkgs.callPackage ./mywikiserver { }; 
  clipboard = pkgs.callPackage ./clipboard { };
  
  firefox-addons = pkgs.callPackage ./firefox-addons { };
  
  # Package that I have to commit to nixpkgs
  megashellextnemo = pkgs.libsForQt5.callPackage ./megashellextnemo {};
}
