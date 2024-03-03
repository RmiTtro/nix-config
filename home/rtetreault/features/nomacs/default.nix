{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Done this way in order to be able to install the plugins
    (nomacs.overrideAttrs(finalAttrs: previousAttrs: {
      src = fetchFromGitHub {
        owner = "nomacs";
        repo = "nomacs";
        rev = finalAttrs.version;
        hash = "sha256-rUREcaJ1NmuJaApg8epR+tpxusgyXhWAEE0SuIjwjsU=";
        fetchSubmodules = true; # Necessary to install the plugins
      };
      
      postInstall =  ''
        ${previousAttrs.postInstall}
        ln -s $out/lib/nomacs-plugins $out/bin/plugins
      '';
    }))
  ];
}