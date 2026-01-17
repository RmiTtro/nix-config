{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    inputs.nix-ttf-ms-win11-auto.packages.${pkgs.stdenv.hostPlatform.system}.ttf-ms-win11-auto-all

    carlito
    caladea
    liberation_ttf
    font-awesome
    nerd-fonts.symbols-only # Mostly used for fancy terminal prompt
  ];
}