{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
  };
  
}