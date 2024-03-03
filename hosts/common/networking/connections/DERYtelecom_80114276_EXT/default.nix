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
      DERYtelecom_80114276_EXT = {
        connection = {
          id = "DERYtelecom_80114276_EXT";
          uuid = "6444217c-36d5-4bf4-9760-19426fc11818";
          type = "wifi";
          zone = "home";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "DERYtelecom_80114276_EXT";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$PSK_DERYtelecom_80114276_EXT";
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
    
    networking.networkmanager.ensureProfiles.environmentFiles = [ config.sops.secrets."wifi_psk/DERYtelecom_80114276_EXT".path ];
    
    sops.secrets."wifi_psk/DERYtelecom_80114276_EXT" = { };
  };
}