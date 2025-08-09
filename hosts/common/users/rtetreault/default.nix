{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
username = "rtetreault";
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
        uid = 1000;
        
        hashedPasswordFile = config.sops.secrets."users_password/${username}".path or null;
        
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

    (lib.mkIf (config.environment?persistence && config.home-manager.users.${username}.permanenceHomeWrap.enable) {
      environment.persistence."/persistent" = {
        users.${username} = {
          directories = config.home-manager.users.${username}.permanenceHomeWrap.directories;
          files = config.home-manager.users.${username}.permanenceHomeWrap.files;
        };
      };
    })
    
    (lib.mkIf (config?sops) { 
      sops.secrets."users_password/${username}" = {
        neededForUsers = true;
      };
    })
    
    (lib.mkIf (config.services.samba.enable) {
      services.samba.settings."${username}Public" = {
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
    
    (lib.mkIf (config.services.samba.enable && config?sops) {
      sops.secrets."samba_passwords/${username}" = {};
      
      systemd.services."${username}SambaAccountManagement" = {
        description = "Create/modify the samba account for the user";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        script = let 
          sambaPasswordPath = config.sops.secrets."samba_passwords/${username}".path;
        in ''
          if [ -f ${sambaPasswordPath} ]; then
          
            # If the user does not have a samba account
            if ! ${pkgs.samba}/bin/pdbedit -u ${username} 1> /dev/null 2>&1; then
            
              # Create user samba account with a blank password
              (echo ""; echo "") | ${pkgs.samba}/bin/pdbedit -u ${username} -a -t 1> /dev/null
              
              # Modify the user samba account to set the password using the nt-hash from the secret file
              ${pkgs.samba}/bin/pdbedit -u ${username} -r --set-nt-hash="$(cat ${sambaPasswordPath})" 1> /dev/null
            
            else # The user already has a samba account
            
              CURRENT_HASH=$(${pkgs.samba}/bin/pdbedit -u ${username} -w | tr ':' $'\n' | head -n 4 | tail -n 1)
              NEW_HASH=$(cat ${sambaPasswordPath})
              
              if [ "$CURRENT_HASH" != "$NEW_HASH" ]; then
                ${pkgs.samba}/bin/pdbedit -u ${username} -r --set-nt-hash="$NEW_HASH" 1> /dev/null
              fi
            fi
            
            # Delete the secret file, it is not needed anymore
            rm ${sambaPasswordPath}
          fi
        '';
        serviceConfig = {
          Type = "oneshot";
        };
      };
    })
  ];
}
