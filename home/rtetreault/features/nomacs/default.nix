{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: lib.mkMerge [
  {
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

  (outputs.lib.addCopyOnChange config {
    xdg.configFile."nomacs/Image Lounge.conf" = {
      text = ''
        [DisplaySettings]
        bgColorNoMacsRGBA=4281545523
        bgColorWidgetRGBA=2852126720
        fontColorRGBA=4292730333
        highlightColorRGBA=4278233855
        iconColorRGBA=4292730333
        themeName312=Dark-Theme.css
      '';
    };
  })
]