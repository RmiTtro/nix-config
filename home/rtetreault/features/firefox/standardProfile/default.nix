{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let 
  profile = "StandardProfile";
in {
  imports = [
    (import ../defaultProfile.nix profile)
    (import ../settings/doNotAutoDisableExtensions.nix profile)
    (import ../custom-search-engines/searxng.nix profile)
    (import ../custom-search-engines/bangs-overrides.nix profile)
    (import ../profile-permanence.nix profile)
    (import ../extensions/dictionaries.nix profile)
    (import ../extensions/darkreader.nix profile)
    (import ../extensions/ublock-origin.nix profile)
  ];

  programs.firefox = {
    profiles.${profile} = {
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

      # Not using this since it will delete all my existing bookmarks that are synced in Firefox sync
      # Will have to sort through my existing bookmarks and add them here
      bookmarks = {
        force = false;
        settings = [
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
      };

      userChrome = ''                         
        /* some css */                        
      '';                                      

      # TODO: It is now possible to also declare the settings of each extension, need to see if this is needed here
      extensions.packages = with inputs.firefox-addons.packages."${pkgs.stdenv.hostPlatform.system}"; with pkgs.firefox-addons; [
        multi-account-containers
        violentmonkey
      ];
    };
  };
}
