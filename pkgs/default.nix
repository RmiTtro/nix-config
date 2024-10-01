{ pkgs ? import <nixpkgs> { } }: rec {

  # Personal scripts
  mywikiserver = pkgs.callPackage ./mywikiserver { }; 
  clipboard = pkgs.callPackage ./clipboard { };
  firefoxExecForVopono = pkgs.callPackage ./firefoxExecForVopono { };
  firefox-vpn = pkgs.callPackage ./firefox-vpn { inherit firefoxExecForVopono; };
  
  firefox-addons = pkgs.callPackage ./firefox-addons { };
  
  # Package that I have to commit to nixpkgs
  megashellextnemo = pkgs.libsForQt5.callPackage ./megashellextnemo {};
}
