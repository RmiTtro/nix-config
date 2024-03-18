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
userHome = config.users.users."${username}".home;
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
          home = userHome;
        };
      };
    }
    
    (lib.mkIf (config ? "sops") 
      (lib.attrsets.setAttrByPath userPasswordSecretConfigPath {
        neededForUsers = true;
      })
    )
    
    (lib.mkIf (config.services.samba.enable) {
      services.samba.shares."${username}Public" = {
        path = "${userHome}/Public";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "${username}";
        "force group" = "users";
      };
    })
    
    (lib.mkIf (config.services.samba.enable && config ? "sops") {
      sops.secrets."samba_passwords/${username}" = {};
      
      system.activationScripts = {
        "${username}SambaAccountCreation" = {
          text = let
            sambaPasswordPath = config.sops.secrets."samba_passwords/${username}".path;
          in
          ''
            if [ -f ${sambaPasswordPath} ]; then
              # Create/modify user samba account with a blank password
              (${pkgs.coreutils-full}/bin/echo ""; ${pkgs.coreutils-full}/bin/echo "") | ${pkgs.samba}/bin/pdbedit -u ${username} -a -t 1> /dev/null
              # Modify the user samba account to set the password using the nt-hash from the secret file
              ${pkgs.samba}/bin/pdbedit -u ${username} -r --set-nt-hash=$(${pkgs.coreutils-full}/bin/cat ${sambaPasswordPath}) 1> /dev/null
              # Delete the secret file, it is not needed anymore
              rm ${sambaPasswordPath}
            fi
          '';
          deps = [ "setupSecrets" ]; # Make it execute after the sops-nix activation script
        };
      };
    })
  ];
}