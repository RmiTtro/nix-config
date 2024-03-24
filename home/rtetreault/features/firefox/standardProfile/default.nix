{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    
    profiles.StandardProfile = {
      id = 0; # Must be different for each profile
      isDefault = true;
      search.engines = {
        /*
        # Exemple to add a search engine
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
        */
      };
      search.force = true;
      search.default = "DuckDuckGo";

      bookmarks = [
        /*
        # Exemple to add a bookmark
        {
          name = "wikipedia";
          tags = [ "wiki" ];
          keyword = "wiki";
          url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
        }
        */
      ];

      settings = (import ../commonSettings.nix) // {
      };

      userChrome = ''                         
        /* some css */                        
      '';                                      

      extensions = with inputs.firefox-addons.packages."${pkgs.system}"; [
        darkreader
        ublock-origin
        multi-account-containers
      ];
    };
  };
}