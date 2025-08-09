# Generated using https://git.sr.ht/~rycee/mozilla-addons-to-nix/
# To update:
#   1. Modify addons.json
#   2. Run the command: nix run git+"https://git.sr.ht/~rycee/mozilla-addons-to-nix/" addons.json /dev/stdout
#   3. Copy and paste the result of the command here
{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "canadian-english-dictionary" = buildFirefoxXpiAddon {
      pname = "canadian-english-dictionary";
      version = "3.1.3";
      addonId = "en-CA@dictionaries.addons.mozilla.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/3819420/canadian_english_dictionary-3.1.3.xpi";
      sha256 = "41ff1c8df7bfa29449d80103ac0f750269fb8c578f9c9bb0a70723c766844ed3";
      meta = with lib;
      {
        description = "For some reason, Mozilla doesn't have a Canadian localization team, but I know that even the British dictionary doesn't quite cut it for the truly patriotic.";
        mozPermissions = [];
        platforms = platforms.all;
      };
    };
    "file-backups" = buildFirefoxXpiAddon {
      pname = "file-backups";
      version = "0.4.0";
      addonId = "file-backups@pmario.github.io";
      url = "https://addons.mozilla.org/firefox/downloads/file/3531085/file_backups-0.4.0.xpi";
      sha256 = "bc80421516542872b987a06964c6b3738cf3354471d86422b5216cbdbcd11144";
      meta = with lib;
      {
        homepage = "https://pmario.github.io/file-backups/";
        description = "TiddlyWiki html-file saving and backup, using a Tower of Hanoi strategy!\n\nLearn more at: https://pmario.github.io/file-backups/\nVideo: recoreded with V0.2.1 https://youtu.be/KVLtID8nElU  which is slightly outdated. But overall info is OK.";
        mozPermissions = [
          "activeTab"
          "tabs"
          "storage"
          "downloads"
          "file:///*.html"
          "file:///*.htm"
        ];
        platforms = platforms.all;
      };
    };
    "webrequest-rules" = buildFirefoxXpiAddon {
      pname = "webrequest-rules";
      version = "4.5";
      addonId = "webrequest@example.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4254198/webrequest_rules-4.5.xpi";
      sha256 = "f0deb1c83aeffa71cf525057c046247f6587056f8cf586f0b7437f435e3bf043";
      meta = with lib;
      {
        homepage = "https://github.com/ichaoX/ext-webRequest";
        description = "Customize web requests by coding JavaScript yourself.";
        mozPermissions = [
          "declarativeNetRequestWithHostAccess"
          "storage"
          "tabs"
          "unlimitedStorage"
          "webRequest"
          "webRequestBlocking"
          "<all_urls>"
        ];
        platforms = platforms.all;
      };
    };
  }