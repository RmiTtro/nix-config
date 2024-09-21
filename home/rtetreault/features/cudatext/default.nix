{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cudaPluginsInputs = lib.attrsets.filterAttrs (name: value: lib.strings.hasPrefix "cuda_" name) inputs;
  funcCudaPluginInputToDerivation = (name: value: (pkgs.runCommand name {src = value;} ''
    mkdir -p $out
    mkdir -p $out/${name}
    cp -r $src/* $out/${name}
  ''));
  cudaPluginsDerivations = lib.attrsets.mapAttrsToList funcCudaPluginInputToDerivation cudaPluginsInputs;
  cudaPluginsDirectory = pkgs.symlinkJoin { name = "cudatext_plugins"; paths = cudaPluginsDerivations; };
  
  cudaThemesInputs = lib.attrsets.filterAttrs (name: value: lib.strings.hasPrefix "cudaTheme_" name) inputs;
  funcCudaThemeInputToDerivation = (name: value: (pkgs.runCommand name {src = value;} ''
    mkdir -p $out
    find $src -name "*.cuda-theme*" -exec cp '{}' $out \;
  ''));
  cudaThemesDerivations = lib.attrsets.mapAttrsToList funcCudaThemeInputToDerivation cudaThemesInputs;
  cudaThemesDirectory = pkgs.symlinkJoin { name = "cudatext_themes"; paths = cudaThemesDerivations; };

  cudaDesiredLexers = [ "Prolog" ];
  funcDesiredLexersToDerivation = (name: (pkgs.runCommand "CudaTextLexer${name}" {src = "${inputs.cudatext-lexers}/${name}";} ''
    mkdir -p $out
    find $src -name "*.lcf" -exec cp '{}' $out \;
    find $src -name "*.cuda-lexmap" -exec cp '{}' $out \;
  ''));
  cudaLexersDerivations = lib.map funcDesiredLexersToDerivation cudaDesiredLexers;
  cudaLexersDirectory = pkgs.symlinkJoin { name = "cudatext_lexers"; paths = cudaLexersDerivations; };
in 
{
  home.packages = with pkgs; [ cudatext ];

  xdg.configFile."cudatext/py" = {
    source = cudaPluginsDirectory;
    recursive = true;
  };
  xdg.configFile."cudatext/data/themes" = {
    source = cudaThemesDirectory;
    recursive = true;
  };
  xdg.configFile."cudatext/data/lexlib" = {
    source = cudaLexersDirectory;
    recursive = true;
  };
  xdg.configFile."cudatext/settings/user.json".source = ./user.json;

  programs.bash.sessionVariables = {
    EDITOR = "cudatext -n -nh -ns -nn";
  };
}
