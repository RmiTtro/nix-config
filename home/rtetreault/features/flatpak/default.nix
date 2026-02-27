{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.persistence."/persistent" = {
    directories = [
      ".var/app"
      ".local/share/flatpak"
    ];
  };
}
