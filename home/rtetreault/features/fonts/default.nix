{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    font-awesome
    nerd-fonts.symbols-only # Mostly used for fancy terminal prompt
  ];
}