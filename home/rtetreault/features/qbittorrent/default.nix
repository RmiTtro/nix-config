{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  isVoponoJail = lib.lists.any (p: p == pkgs.voponojail) config.home.packages;
in {
  home.packages = with pkgs; [ qbittorrent ];

  xdg.configFile."qBittorrent/qBittorrent.conf".text = ''
    [LegalNotice]
    Accepted=true
  '';

  permanenceHomeWrap = {
    directories = [
      # ".config/qBittorrent" # configs saved in here, not persisted because I don't think it is necessary
      ".local/share/qBittorrent" # The currently downloading torrent are saved in here
    ];
  };

  home.shellAliases = {
    ${if isVoponoJail then "qbittorrent-vpn" else null} = "voponojail qbittorrent";
  }; 
}