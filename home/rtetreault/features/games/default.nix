{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ (bottles.override { removeWarningPopup = true; }) ];

  home.persistence."/persistent" = {
    directories = [
      ".local/share/bottles"
      ".local/share/Steam"
      "Games"
      ".factorio"
      ".renpy"
      ".config/unity3d"
      ".config/retroarch"
    ];
  };
}
