{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: lib.mkMerge [
  {
    home.packages = with pkgs; [ nomacs ];
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