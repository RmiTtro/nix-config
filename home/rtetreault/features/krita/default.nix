{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ krita ];

  # * Ressources path: $HOME/.local/share/krita
  # * Others path:
  #   * $HOME/.config/kritarc
  #   * $HOME/.config/kritadisplayrc

  xdg.dataFile."krita/palettes" = {
    source = ./palettes;
    recursive = true;
  };

  home.persistence."/persistent" = {
    files = [
      ".local/share/krita/resourcecache.sqlite"
    ];
  };
}