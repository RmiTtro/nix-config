{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
inherit (pkgs) copyq runCommand;
in
{
  # Not started by systemd since it make it light themed
  #services.copyq.enable = true;
  #services.copyq.systemdTarget = "tray.target ";
  
  
  home.packages = [ copyq ];
  
  # Put a modified version of the copyq desktop shortcut in the nix store, the modification is to remove "show" from the execution command to have a silent startup
  # The copyq desktop shortcut copied in the store is then added in the autostart directory of the user
  xdg.configFile."autostart/copyq.desktop".source = runCommand "copyq.desktop" {} ''
    cp ${pkgs.copyq}/share/applications/com.github.hluk.copyq.desktop $out
    substituteInPlace $out --replace "show" ""
  '';
  
  xdg.configFile."copyq/copyq-commands.ini".source = ./copyq-commands.ini;
}