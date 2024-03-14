# Solaar is to manage logitech device
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;
  
  environment.systemPackages = with pkgs; [ 
    # Did not do it this way since it showed the window on startup 
    #( pkgs.makeAutostartItem { name = "solaar"; package = pkgs.solaar; } )
    
    (runCommand "solaar.desktop" {} ''
      mkdir -p $out/etc/xdg/autostart
      cp ${pkgs.solaar}/share/applications/solaar.desktop $out/etc/xdg/autostart
      substituteInPlace $out/etc/xdg/autostart/solaar.desktop --replace "Exec=solaar" "Exec=solaar -w hide"
    '')
  ];
}