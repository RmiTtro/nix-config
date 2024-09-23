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
      SM-S928W2301 = {
        connection = {
          id = "SM-S928W2301";
          uuid = "420183b0-4a9c-4901-9131-bade63e9a7c2";
          type = "wifi";
          zone = "home";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "SM-S928W2301";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$PSK_SMS928W2301";
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
    
    networking.networkmanager.ensureProfiles.environmentFiles = [ config.sops.secrets."wifi_psk/SM-S928W2301".path ];
    
    sops.secrets."wifi_psk/SM-S928W2301" = { };
  };
}