{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;

    languagePacks = [
      "en-CA"
      "fr"
    ];
  };
}