{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  virtualisation.virtualbox.host.enable = true;
  
  virtualisation.virtualbox.host.enableExtensionPack = true;
}