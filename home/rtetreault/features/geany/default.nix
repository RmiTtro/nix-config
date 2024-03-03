{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ geany ];
  xdg.configFile."geany/colorschemes".source = inputs.geany-themes.outPath + "/colorschemes";
  xdg.configFile."geany/geany.conf".source = ./geany.conf;
}