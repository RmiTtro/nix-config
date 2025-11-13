{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Followed instruction from https://nixos.wiki/wiki/Steam
  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };

  environment.systemPackages = with pkgs; [
    steam-run
  ];
}