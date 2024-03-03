{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.file."Desktop/Secure Firefox.desktop" = {
    source = ./${"Secure Firefox"}.desktop;
    executable = true;
  };

  programs.firefox = {
    enable = true;
    
    profiles.SecureProfile = {
      id = 1; # Must be different for each profile
      isDefault = false;
 
      search.force = true;
      search.default = "DuckDuckGo";

      settings = {
        # "browser.startup.page" = 3; # Allow the browser to remmember the tabs when closed
        "browser.privatebrowsing.autostart" = true; # Prevent the browser from remmembering histo
      } // (import ../commonSettings.nix);

      userChrome = ''                         
        /* some css */                        
      '';                                      
    };
  };
}