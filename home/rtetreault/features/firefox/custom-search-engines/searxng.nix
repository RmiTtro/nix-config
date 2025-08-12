profile:

{lib, pkgs, ...}@args: let
  inherit (lib.strings) toLower; 
  searxServerHostname = "asus-laptop-tuf517zr";
  searxServerPort = "8888";
  usedHostname = if (toLower (args.osConfig.networking.hostName or "")) == searxServerHostname then "localhost" else searxServerHostname;
in {
  programs.firefox.profiles."${profile}".search.engines = {
    "SearXNG" = { 
      urls = [{
        template = "http://${usedHostname}:${searxServerPort}/search";
        params = [
          { name = "q"; value = "{searchTerms}"; }
          { name = "category_general"; value = ""; }
          { name = "language"; value = "auto"; }
          { name = "time_range"; value = ""; }
          { name = "safesearch"; value = "2"; }
          { name = "theme"; value = "simple"; }
        ];
      }];

      icon = "${pkgs.searxng}/share/static/themes/simple/img/favicon.svg";
      definedAliases = [ "@searx" "@searxng" ];
    };
  };
}