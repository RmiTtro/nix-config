{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
username = "rtetreault";
userPasswordSecretConfigPath = [ "sops" "secrets" "users_password/${username}" ];
userPasswordSecretPathConfigPath = userPasswordSecretConfigPath ++ [ "path" ];
isUserPasswordSecretPathExists = lib.attrsets.hasAttrByPath userPasswordSecretPathConfigPath config;
getUserPasswordSecretPath = lib.attrsets.getAttrFromPath userPasswordSecretPathConfigPath config;
in {
  config = lib.mkMerge [
    {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
      users.users."${username}" = {
        # TODO: You can set an initial password for your user.
        # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
        # Be sure to change it (using passwd) after rebooting!
        # initialPassword = "correcthorsebatterystaple";
        isNormalUser = true;
        description = "Rémi Tétreault";
        
        hashedPasswordFile = 
          if isUserPasswordSecretPathExists
          then getUserPasswordSecretPath
          else null;
        
        openssh.authorizedKeys.keys = [
          # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
        ];
        extraGroups = 
          [ "wheel" ] 
          ++ lib.lists.optional config.networking.networkmanager.enable "networkmanager";
      };
    
      home-manager.users = {
        # Import your home-manager configuration
        "${username}" = import ../../../../home/${username}/${config.hostname}.nix {
          username = config.users.users."${username}".name;
          home = config.users.users."${username}".home;
        };
      };
    }
    
    (lib.mkIf (config ? "sops") 
      (lib.attrsets.setAttrByPath userPasswordSecretConfigPath {
        neededForUsers = true;
      })
    )
  ];
}