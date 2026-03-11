{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-9da7f1c,
  ...
}: let
  # TODO: Use the most recent version when this pull request is merged: https://github.com/NixOS/nixpkgs/pull/483392/changes/ec760fdc831ddc5c284388ec4614b8ea3767a37a
  # Use a previous version of filen, the one based on the appimage instead of builded from the source
  # The one from the source is a bit buggy, like it save its config in ~/.config/Electron instead of ~/.config/@filen/desktop
  filen-desktop = pkgs-9da7f1c.filen-desktop;
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