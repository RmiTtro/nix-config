{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  profile = "VPNProfile";
  isVoponoJail = lib.lists.any (p: p == pkgs.voponojail) config.home.packages;
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

      settings = {
        # The vpn provide a dns, no need to use DNS-over-HTTPS 
        "network.trr.mode" = 5; 
      };
    };
  };

  home.shellAliases = {
    ${if isVoponoJail then "firefox-vpn" else null} = "voponojail firefox -P ${profile}";
  }; 
}
