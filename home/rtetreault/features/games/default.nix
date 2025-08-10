{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ (bottles.override { removeWarningPopup = true; }) ];

  permanenceHomeWrap = {
    directories = [
      ".local/share/bottles"
      ".local/share/Steam"
      "Games"
      ".factorio"
      ".renpy"
      ".config/unity3d"
    ];
  };
}
