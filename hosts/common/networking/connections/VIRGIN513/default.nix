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
      VIRGIN513 = { 
        connection = { 
          id = "VIRGIN513"; 
          type = "wifi"; 
          uuid = "8017eb2d-67d9-406b-b73a-2a13981494ac";
          zone = "home";
        };
        wifi = { 
          mode = "infrastructure"; 
          ssid = "VIRGIN513"; 
        };
        ipv4 = { 
          method = "auto"; 
        }; 
        ipv6 = { 
          addr-gen-mode = "default"; 
          method = "auto"; 
        };
        wifi-security = { 
          auth-alg = "open"; 
          key-mgmt = "wpa-psk"; 
          psk = "$PSK_VIRGIN513"; 
        }; 
        proxy = { 
        };
      };
    };
    
    networking.networkmanager.ensureProfiles.environmentFiles = 
      lib.optional config.sops.enable config.sops.secrets."wifi_psk/VIRGIN513".path;
    
    sops.secrets."wifi_psk/VIRGIN513" = { };
  };
}