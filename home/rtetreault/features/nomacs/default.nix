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
  
  xdg.configFile."nomacs/HomeManagerInit_ImageLounge.conf" = {
    text = ''
      [DisplaySettings]
      bgColorNoMacsRGBA=4281545523
      bgColorWidgetRGBA=2852126720
      fontColorRGBA=4292730333
      highlightColorRGBA=4278233855
      iconColorRGBA=4292730333
      themeName312=Dark-Theme.css
    '';
    onChange = ''
      rm -f ${config.xdg.configHome}/nomacs/ImageLounge.conf
      cp ${config.xdg.configHome}/nomacs/HomeManagerInit_ImageLounge.conf ${config.xdg.configHome}/nomacs/ImageLounge.conf
      chmod u+w ${config.xdg.configHome}/nomacs/ImageLounge.conf
    '';
  };
}