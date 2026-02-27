{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  filen-desktop = pkgs.filen-desktop;
in
{
  imports = [ ../cloud-options.nix ];

  cloud.enable = true;
  cloud.path = "${config.home.homeDirectory}/Filen";

  home.packages = [ filen-desktop ];
  
  xdg.configFile."autostart/filen-desktop.desktop".source = "${filen-desktop}/share/applications/filen-desktop.desktop";

  home.persistence."/persistent" = {
    directories = [
      "Filen"
      ".config/@filen"
    ];
  };
}