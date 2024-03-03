{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs = {
    # You can add overlays here
    overlays = builtins.attrValues outputs.overlays; 
    
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };
}