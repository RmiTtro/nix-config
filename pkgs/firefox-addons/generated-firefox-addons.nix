# Generated using https://git.sr.ht/~rycee/mozilla-addons-to-nix/
{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "file-backups" = buildFirefoxXpiAddon {
      pname = "file-backups";
      version = "0.4.0";
      addonId = "file-backups@pmario.github.io";
      url = "https://addons.mozilla.org/firefox/downloads/file/3531085/file_backups-0.4.0.xpi";
      sha256 = "bc80421516542872b987a06964c6b3738cf3354471d86422b5216cbdbcd11144";
      meta = with lib;
      {
        homepage = "https://pmario.github.io/file-backups/";
        description = "TiddlyWiki html-file saving and backup, using a Tower of Hanoi strategy!\n\nLearn more at: <a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/ff81a25bd90764a5e59099229353d04277ad071c87e22267748cd84e337bbfc6/https%3A//pmario.github.io/file-backups/\" rel=\"nofollow\">https://pmario.github.io/file-backups/</a>\nVideo: recoreded with V0.2.1 <a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/6ea35f4c7c1555906034e73c75a79ebcff27f3a38ef7bbbef3a47fc76762b923/https%3A//youtu.be/KVLtID8nElU\" rel=\"nofollow\">https://youtu.be/KVLtID8nElU</a>  which is slightly outdated. But overall info is OK.";
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
      version = "4.4";
      addonId = "webrequest@example.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4219177/webrequest_rules-4.4.xpi";
      sha256 = "d5283b995e357fce4d7fdce856552fbcce120cfdfcc7b5fe7d57fc2c612206da";
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