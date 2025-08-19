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
    sops.enable = true;
    sops.defaultSopsFile = ../secrets.yaml;
    sops.defaultSopsFormat = "yaml";

    sops.age.sshKeyPaths = [ "/etc/ssh/id_ed25519" ];

    fileSystems."/etc/ssh".neededForBoot = config.environment.persistence."/persistent".enable or false;
  };
}