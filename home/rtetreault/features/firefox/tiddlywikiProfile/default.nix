{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  profile = "TiddlywikiProfile";
  isMegasync = lib.lists.any (p: p == pkgs.megasync) config.home.packages;
in {
  imports = [
    (import ../defaultProfile.nix profile)
    (import ../settings/doNotAutoDisableExtensions.nix profile)
    (import ../createSpecificProfileDesktopIcon.nix  profile "My Wikis")
    (import ../profile-permanence.nix profile)
    (import ../extensions/dictionaries.nix profile)
  ];
  
  programs.firefox = {
    profiles.${profile} = {
      id = 2; # Must be different for each profile

      bookmarks = {
        force = true;
        settings = [
          {
            name = "Bookmarks Toolbar";
            toolbar = true;
            bookmarks = (
              []
              ++ (
                lib.lists.optional isMegasync {
                  name = "myWikis";
                  url = "file://${config.home.homeDirectory}/Downloads/myWikis/";
                }
              )
            );
          }
        ];
      };

      settings = {
        "browser.toolbars.bookmarks.visibility" = "newtab";
      };

      userChrome = ''                         
        /* some css */                        
      '';                                      

      # TODO: It is now possible to also declare the settings of each extension, need to see if this is needed here
      extensions.packages = with inputs.firefox-addons.packages."${pkgs.system}"; with pkgs.firefox-addons; [
        file-backups
        webrequest-rules
        violentmonkey
      ];
    };
  };
  
  home.file = {
    ${if isMegasync then "Downloads/myWikis" else null}.source = 
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/MEGA/myWikis";
  };  
    
}
