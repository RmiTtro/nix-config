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
  
  config = lib.mkMerge [
    {
      programs.firefox = {
        profiles.TiddlywikiProfile = {
          id = 2; # Must be different for each profile
          isDefault = false;
          search.force = true;
          search.default = "DuckDuckGo";
          bookmarks = [
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

          settings = (import ../commonSettings.nix) // {
            "browser.toolbars.bookmarks.visibility" = "newtab";
          };
    
          userChrome = ''                         
            /* some css */                        
          '';                                      
    
          extensions = with inputs.firefox-addons.packages."${pkgs.system}"; with pkgs.firefox-addons; [
            file-backups
            webrequest-rules
            violentmonkey
          ];
        };
      };
      
      home.file = import ../createSpecificProfileDesktopIcon.nix {inherit pkgs; name="My Wikis"; profile = "TiddlywikiProfile";};
    }
    
    (lib.mkIf isMegasync {
      home.file."Downloads/myWikis".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/MEGA/myWikis";
    })
  ];
}