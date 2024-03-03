{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  # These variables definition do not cause any error thanks to the Nix language being lazy
  ageKeyUserHomeConfigPath = [ "users" "users" "rtetreault" "home" ];
  isUserHomeConfigPathExists = lib.attrsets.hasAttrByPath ageKeyUserHomeConfigPath config;
  userHomeConfigPathValue = lib.attrsets.getAttrFromPath ageKeyUserHomeConfigPath config;
  ageKeyPath = "${userHomeConfigPathValue}/.config/sops/age/keys.txt";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
      
  assertions = [
    {
      assertion = isUserHomeConfigPathExists;
      message = "User rtetreault is necessary to set the age key path for sops.";
    }
  ];
  
  sops.defaultSopsFile = ../../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = 
    if isUserHomeConfigPathExists
    then ageKeyPath
    else null;
}