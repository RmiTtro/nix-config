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
      DERYtelecom_80114276 = {
        connection = {
          id = "DERYtelecom_80114276";
          uuid = "c31348bb-c16f-4951-b993-d2c8626ffeee";
          type = "wifi";
          zone = "home";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "DERYtelecom_80114276";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$PSK_DERYtelecom_80114276";
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
    
    networking.networkmanager.ensureProfiles.environmentFiles = 
      lib.optional config.sops.enable config.sops.secrets."wifi_psk/DERYtelecom_80114276".path;
    
    sops.secrets."wifi_psk/DERYtelecom_80114276" = { };
  };
}