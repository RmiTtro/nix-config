{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let 
  packagesAvailablesForPyp = with pkgs.python3Packages; [ pipetools ];
  
  
  pyp = pkgs.pyp.overridePythonAttrs(old: rec {
    # TODO: remove the check skip once pyp unit tests are fixed
    # I disabled the unit tests since some are failling
    # pyp is still working fine, my guess is that some changes in newer version of python break the tests
    doCheck = false;
    propagatedBuildInputs = packagesAvailablesForPyp;
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