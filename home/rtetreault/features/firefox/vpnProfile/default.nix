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
      search.default = "ddg";

      settings = (import ../commonSettings.nix) // { 
        "extensions.autoDisableScopes" = 0; # This prevent all extensions installed by nix to be disabled 
      };

      userChrome = ''                         
        /* some css */                        
      '';

      # TODO: It is now possible to also declare the settings of each extension, need to see if this is needed here
      extensions.packages = with inputs.firefox-addons.packages."${pkgs.system}"; with pkgs.firefox-addons; [
        french-dictionary
        canadian-english-dictionary
        darkreader
        ublock-origin
      ];  
    };
  };

  home.packages = with pkgs; [ firefox-vpn firefoxExecForVopono ];

  permanenceHomeWrap = {
    directories = [
      {
        directory = ".mozilla/firefox/VPNProfile";
        ${if config.permanenceHomeWrap.isUsingHomeManagerModule then "method" else null} = "bindfs";
      }
    ];
  };
}
