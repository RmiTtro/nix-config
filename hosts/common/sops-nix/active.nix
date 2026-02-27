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

    # Must do it this way since the last version of impermanence prevent declaring /etc/ssh neededForBoot
    # See https://github.com/nix-community/impermanence/issues/294 for more info
    sops.age.sshKeyPaths = let
      persistentPrefix = (if config.environment.persistence."/persistent".enable then "/persistent" else "");
    in [ 
      (persistentPrefix + "/etc/ssh/id_ed25519") 
    ];
  };
}