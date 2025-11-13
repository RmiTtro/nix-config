{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  profile = "TiddlywikiProfile";
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
                lib.lists.optional config.cloud.enable  {
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
      extensions.packages = with inputs.firefox-addons.packages."${pkgs.stdenv.hostPlatform.system}"; with pkgs.firefox-addons; [
        file-backups
        webrequest-rules
        violentmonkey
      ];
    };
  };
  
  home.file = {
    ${if config.cloud.enable then "Downloads/myWikis" else null}.source = 
      config.lib.file.mkOutOfStoreSymlink "${config.cloud.path}/myWikis";
  };  
    
}
