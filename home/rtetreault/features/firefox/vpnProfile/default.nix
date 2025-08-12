{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  profile = "VPNProfile";
in {
  imports = [
    (import ../defaultProfile.nix profile)
    (import ../settings/doNotAutoDisableExtensions.nix profile)
    (import ../custom-search-engines/searxng.nix profile)
    (import ../profile-permanence.nix profile)
    (import ../extensions/dictionaries.nix profile)
    (import ../extensions/darkreader.nix profile)
    (import ../extensions/ublock-origin.nix profile)
  ];

  programs.firefox = {
    profiles.${profile} = {
      id = 3; # Must be different for each profile

      userChrome = ''                         
        /* some css */                        
      ''; 
    };
  };

  home.packages = with pkgs; [ firefox-vpn firefoxExecForVopono ];
}
