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

  home.file = import ../createSpecificProfileDesktopIcon.nix {inherit pkgs; name="Secure Firefox"; profile = "SecureProfile";};

  programs.firefox = {
    profiles.SecureProfile = {
      id = 1; # Must be different for each profile
      isDefault = false;

      search.force = true;
      search.default = "ddg";

      settings = (import ../commonSettings.nix) // {
        "browser.startup.page" = 0; # Start on about:blank
        "browser.privatebrowsing.autostart" = true; # Prevent the browser from remmembering histo
      };

      userChrome = ''                         
        /* some css */                        
      '';                                      
    };
  };
}
