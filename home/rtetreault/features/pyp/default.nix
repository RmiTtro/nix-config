{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let 
  # pipetools is not part of nixpkgs, so I have to implement it myself
  pipetools = with pkgs; with python3Packages; callPackage ./pipetools.nix {
    buildPythonPackage = buildPythonPackage;
    pytestCheckHook = pytestCheckHook;
    pytest-cov = pytest-cov;
    setuptools = setuptools;
  };
  
  packagesAvailablesForPyp = with pkgs.python3Packages; [ pipetools ];
  
  pyp = pkgs.python3Packages.pyp.overridePythonAttrs(old: rec {
    propagatedBuildInputs = old.propagatedBuildInputs ++ packagesAvailablesForPyp;
  });
in 
{
  home.packages = with pkgs; [
    pyp
  ];
  
  programs.bash.sessionVariables = {
    PYP_CONFIG_PATH = "$HOME/.pypconfig.py";
  };
  
  home.file.".pypconfig.py" = {
    enable = true;
    source = ./pypconfig.py;
  };
}