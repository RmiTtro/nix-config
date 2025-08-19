{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  # This fake option is just so the other modules can check if sops is enabled
  options = {
    sops.enable = lib.mkEnableOption "Sops";
  };
  
  config = {
    # Note that the decrypted secrets are made available in ~/.config/sops-nix/secrets
    sops = {
      enable = true;
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = ../../secrets.yaml;
    };

    permanenceHomeWrap = {
      files = [
        ".config/sops/age/keys.txt"
      ];
    };
  };
}