{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
megasync = pkgs.megasync;
in
{
  # Use autostart instead of systemd since systemd make a window appear instead of doing a silent start
  # I think the reason it does that is because the systemd unit is executed to early during desktop environnment init phase
  # I could not find a systemd target that was performed far enough to not cause these issues (xdg-desktop-autostart.target might work)
  #services.megasync.enable = true;
  
  home.packages = [ megasync ];
  
  xdg.configFile."autostart/megasync.desktop".source = "${megasync}/share/applications/megasync.desktop";
  
  # Necessary for megasync to build
  # https://github.com/NixOS/nixpkgs/issues/290949
  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01"
  ];
}