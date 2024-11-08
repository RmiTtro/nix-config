{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = config.hostname;
        "netbios name" = config.hostname;
        security = "user";
        # "use sendfile" = "yes";
        # "max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        # Make sure the ip address of the home network is in hosts allow
        "hosts allow" = "192.168.1. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
    }; 
  };

  # Necessary to connect to a computer using it's netbios name
  # https://nixos.wiki/wiki/Samba#Firewall_configuration
  networking.firewall = lib.mkIf config.networking.firewall.enable { 
    extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };

  # This is to avertise the share
  services.samba-wsdd = {
    enable = false;
    openFirewall = true;
  };
}