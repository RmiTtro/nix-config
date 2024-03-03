{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.networking.networkmanager.enable {
    networking.networkmanager.ensureProfiles.profiles = { 
      DERYtelecom_80114276_5G = {
        connection = {
          id = "DERYtelecom_80114276_5G";
          uuid = "51aa852f-71a5-4c9d-93cb-daf0e0f253c6";
          type = "wifi";
          zone = "home";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "DERYtelecom_80114276_5G";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$PSK_DERYtelecom_80114276_5G";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = {
        };
      };
    };
    
    networking.networkmanager.ensureProfiles.environmentFiles = [ config.sops.secrets."wifi_psk/DERYtelecom_80114276_5G".path ];
    
    sops.secrets."wifi_psk/DERYtelecom_80114276_5G" = { };
  };
}