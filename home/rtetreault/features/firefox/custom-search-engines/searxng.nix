pkgs: {
  "SearXNG" = { 
    urls = [{
      template = "http://localhost:8888/search";
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
}