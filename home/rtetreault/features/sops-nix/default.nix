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
  
  # Note that the decrypted secrets are made available in ~/.config/sops-nix/secrets
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets.yaml;
  };

  permanenceHomeWrap = {
    files = [
      ".config/sops/age/keys.txt"
    ];
  };
}