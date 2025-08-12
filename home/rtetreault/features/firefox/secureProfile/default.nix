{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let 
  profile = "SecureProfile";
in {
  imports = [
    (import ../defaultProfile.nix profile)
    (import ../createSpecificProfileDesktopIcon.nix  profile "Secure Firefox")
  ];

  programs.firefox = {
    profiles.${profile} = {
      id = 1; # Must be different for each profile

      settings = {
        "browser.startup.page" = 0; # Start on about:blank
        "browser.privatebrowsing.autostart" = true; # Prevent the browser from remmembering histo
      };

      userChrome = ''                         
        /* some css */                        
      '';                                      
    };
  };
}
