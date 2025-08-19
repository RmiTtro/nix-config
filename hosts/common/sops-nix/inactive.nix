# Necessary to use this module if we want to disable sops
# Done this way so that any modules that use sops don't have to check if it is part of config
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # This fake option is just so the other modules can check if sops is enabled
  options = {
    sops.enable = lib.mkEnableOption "Sops";
  };
  
  config = {
    sops.enable = false;
    # Unfortunately, the real sops-nix module does not have an enable option, so 
    # I have to do something like this to disable the secrets defined in other modules
    sops.secrets = lib.mkForce { };
  };
}