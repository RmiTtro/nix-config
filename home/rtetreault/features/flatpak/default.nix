{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  permanenceHomeWrap = {
    directories = [
      ".var/app"
      ".local/share/flatpak"
    ];
  };
}
