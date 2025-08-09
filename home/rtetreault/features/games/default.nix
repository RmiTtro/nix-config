{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  permanenceHomeWrap = {
    directories = [
      "Games"
      ".factorio"
      ".renpy"
      ".local/share/Steam"
    ];
  };
}
