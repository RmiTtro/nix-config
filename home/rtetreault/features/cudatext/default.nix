{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cudaPluginsInputs = lib.attrsets.filterAttrs (name: value: lib.strings.hasPrefix "cuda_" name) inputs;
  cudaPluginsConfigs = lib.attrsets.concatMapAttrs (name: value: {"cudatext/py/${name}".source = value;}) cudaPluginsInputs;
  cudaThemesInputs = lib.attrsets.filterAttrs (name: value: lib.strings.hasPrefix "cudaTheme_" name) inputs;
  cudaThemesFilesPath = builtins.concatMap (p: builtins.filter (lib.strings.hasInfix ".cuda-theme-") (lib.filesystem.listFilesRecursive p)) (builtins.attrValues cudaThemesInputs);
  getLowerCaseBaseNameForKey = p: "${builtins.unsafeDiscardStringContext (lib.strings.toLower (builtins.baseNameOf p))}";
  cudaThemesConfig = lib.attrsets.mergeAttrsList (builtins.map (p: {"cudatext/data/themes/${getLowerCaseBaseNameForKey p}".source = p;}) cudaThemesFilesPath);
in 
{
  home.packages = with pkgs; [ cudatext ];

  xdg.configFile = cudaPluginsConfigs 
                   // cudaThemesConfig 
                   // { "cudatext/settings/user.json".source = ./user.json; };
                   
  programs.bash.sessionVariables = {
    EDITOR = "cudatext -n -nh -ns -nn";
  };
}