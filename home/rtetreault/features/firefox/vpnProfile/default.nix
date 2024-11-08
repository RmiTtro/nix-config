{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../firefox.nix
  ];

  programs.firefox = {
    profiles.VPNProfile = {
      id = 3; # Must be different for each profile
      isDefault = false;

      search.engines = (import ../custom-search-engines/searxng.nix pkgs) // { };

      search.force = true;
      search.default = "DuckDuckGo";

      settings = (import ../commonSettings.nix) // { };

      userChrome = ''                         
        /* some css */                        
      '';

      extensions = with inputs.firefox-addons.packages."${pkgs.system}"; [
        darkreader
        ublock-origin
      ];  
    };
  };

  home.packages = with pkgs; [ firefox-vpn firefoxExecForVopono ];
}