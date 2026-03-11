{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-9da7f1c,
  ...
}: {

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  
  home-manager = {
    extraSpecialArgs = { 
      inherit inputs outputs pkgs-9da7f1c;
    };
    sharedModules = [ 
      outputs.homeManagerModules.addCopyOnChange 
    ];
  };
  
}