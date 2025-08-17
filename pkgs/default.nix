{ pkgs ? import <nixpkgs> { } }: rec {

  # Personal scripts
  clipboard = pkgs.callPackage ./clipboard { };
  firejailExecForVopono = pkgs.callPackage ./firejailExecForVopono { };
  voponojail = pkgs.callPackage ./voponojail { inherit firejailExecForVopono; };
  
  firefox-addons = pkgs.callPackage ./firefox-addons { };
  
  # Package that I have to commit to nixpkgs
  megashellextnemo = pkgs.libsForQt5.callPackage ./megashellextnemo {};

  powerline-go-fhs = pkgs.callPackage ./powerline-go-fhs {};
}
