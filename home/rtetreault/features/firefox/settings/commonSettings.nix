profile:

{inputs, pkgs, lib, ...}: let
  # Convert betterfox user.js file into nix code representing an attribute set
  betterfox-nix-file = (pkgs.runCommand 
    "betterfox.nix" 
    {
      src = "${inputs.betterfox}/user.js";
    } 
    # first -e: add a { as the first line
    # second -e: add a } as the last line
    # third -e: change line comment symbol from // to # for comment spanning a complete line
    # fourth -e: change line comment symbol from // to # for comment after a user_pref
    # fifth -e: change user_pref("key", "value"); to "key" = "value";
    ''
      sed -r -e '1i{' -e '$a}' -e 's/^\/\//#/' -e 's/^(user_pref\(.+\);\s*)\/\//\1#/' -e 's/^user_pref\((".+")\s*,\s*(.+)\);/\1 = \2;/' $src > $out
    ''
  );
  # Load the created attribute set
  betterfox-nix = (import betterfox-nix-file);
in  
{ 
  # The profiles settings are based on betterfox with some overrides
  # For more infos, see: https://github.com/yokoffing/Betterfox
  programs.firefox.profiles.${profile}.settings = betterfox-nix // {
    # PREF: I want to use the same search engine for default and private 
    "browser.search.separatePrivateDefault.ui.enabled" = false;
    
    # PREF: disable login manager
    "signon.rememberSignons" = false;

    # These 2 settings correspond to the 2 checkbox under Privacy & Security > Froms and Autofill
    "extensions.formautofill.addresses.enabled" = false;
    "extensions.formautofill.creditCards.enabled" = false;

    # PREF: enforce certificate pinning
    # [ERROR] MOZILLA_PKIX_ERROR_KEY_PINNING_FAILURE
    # 1 = allow user MiTM (such as your antivirus) (default)
    # 2 = strict
    "security.cert_pinning.enforcement_level" = 2;

    # PREF: set DNS-over-HTTPS provider
    "network.trr.uri" = "https://dns.dnswarden.com/00000000000000000000048"; # Hagezi Light + TIF

    # PREF: enforce DNS-over-HTTPS (DoH)
    "network.trr.mode" = lib.mkDefault 2;
    "network.trr.max-fails" = 5;

    # PREF: display the installation prompt for all extensions even the recommended extension
    "extensions.postDownloadThirdPartyPrompt" = false;

    # PREF: restore search engine suggestions
    "browser.search.suggest.enabled" = true;

    # PREF: don't show weather on New Tab page
    "browser.newtabpage.activity-stream.showWeather" = false;
    
    # Don't show an import button in the toolbar
    # The true value is to trick the browser into thinking it already added it
    "browser.bookmarks.addedImportButton" = true;
    
    # Control the toolbar visibility
    # Possibles values:
    #   - always
    #   - never
    #   - newtab
    "browser.toolbars.bookmarks.visibility" = lib.mkDefault "never";
    
    # Control what the browser show when starting:
    # Possibles values:
    #   - 0 : blank page (about:blank)
    #   - 1 : web page defined in Browser.startup.homepage (default)
    #   - 2 : last visited page
    #   - 3 : resume browser session
    "browser.startup.page" = lib.mkDefault 3;
    
    # Set to true to disable histo
    "browser.privatebrowsing.autostart" = lib.mkDefault false;

    # Disable annoying beep sound that play when performing a search
    "accessibility.typeaheadfind.enablesound" = false;
  };
}