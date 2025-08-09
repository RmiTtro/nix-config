{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [ inputs.sops-nix.nixosModules.sops ];
  
  sops.defaultSopsFile = ../secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.sshKeyPaths = [ "/etc/ssh/id_ed25519" ];

  fileSystems."/etc/ssh".neededForBoot = config.environment.persistence."/persistent".enable or false;  
}