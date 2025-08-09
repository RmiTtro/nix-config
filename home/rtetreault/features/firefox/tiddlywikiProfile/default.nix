{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let 
  isMegasync = lib.lists.any (p: p == pkgs.megasync) config.home.packages;
in {
  imports = [
    ../firefox.nix
  ];
  
  programs.firefox = {
    profiles.TiddlywikiProfile = {
      id = 2; # Must be different for each profile
      isDefault = false;
      search.force = true;
      search.default = "ddg";
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

      settings = (import ../commonSettings.nix) // {
        "browser.toolbars.bookmarks.visibility" = "newtab";
        "extensions.autoDisableScopes" = 0; # This prevent all extensions installed by nix to be disabled
      };

      userChrome = ''                         
        /* some css */                        
      '';                                      

      # TODO: It is now possible to also declare the settings of each extension, need to see if this is needed here
      extensions.packages = with inputs.firefox-addons.packages."${pkgs.system}"; with pkgs.firefox-addons; [
        french-dictionary
        canadian-english-dictionary
        file-backups
        webrequest-rules
        violentmonkey
      ];
    };
  };

  permanenceHomeWrap = {
    directories = [
      {
        directory = ".mozilla/firefox/TiddlywikiProfile";
        ${if config.permanenceHomeWrap.isUsingHomeManagerModule then "method" else null} = "bindfs";
      }
    ];
  };
  
  home.file = {
    ${if isMegasync then "Downloads/myWikis" else null}.source = 
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/MEGA/myWikis";
  } // import ../createSpecificProfileDesktopIcon.nix {inherit pkgs; name="My Wikis"; profile = "TiddlywikiProfile";};  
    
}
