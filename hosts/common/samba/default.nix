{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = ${config.hostname}
      netbios name = ${config.hostname}
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      # Make sure the ip address of the home network is in hosts allow
      hosts allow = 192.168.1. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
  };
  
  # This is to avertise the share
  services.samba-wsdd = {
    enable = false;
    openFirewall = true;
  };
}