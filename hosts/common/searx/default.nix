{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Note that it is actually searxng that is used
  services.searx = {
    enable = true;

    # These settings come from: https://docs.searxng.org/admin/installation-searxng.html
    settings = {
      # In NixOS, it is already at true by default 
      # use_default_settings = true;

      general = {
        debug = false;
        instance_name = "SearXNG";
      };

      search = {
        # Filter results:
        # - 0: None
        # - 1: Moderate
        # - 2: Strict
        safe_search = 2;
        autocomplete = "duckduckgo";
      };

      server = {
        # Is overwritten by ${SEARXNG_SECRET}
        secret_key = "@SEARX_SECRET_KEY@";
        # Limiter is to protect against bot, only useful if the server is public
        limiter = false;
        # When the image proxy is activated, the images presented in the results of a search performed on a searxng server 
        # will be downloaded from the searxng server instead of their original website, allowing the url of the user that 
        # made the search to not be sent to the images services
        image_proxy = false;
        # public URL of the instance, to ensure correct inbound links. Is overwritten
        # by ${SEARXNG_URL}.
        # base_url = "http://example.com/location";
      };

      /*
      # Linked to rate limiter and bot protection of SearXNG
      # NixOS can handle the creation of the Redis server and this setting by setting to true services.searx.redisCreateLocally 
      redis = {
        # URL to connect redis database. Is overwritten by ${SEARXNG_REDIS_URL}.
        url = "unix:///usr/local/searxng-redis/run/redis.sock?db=0";
      };
      */

      ui = {
        # Add an hash to the static file served by the searxng server
        # This hash is used by a web browser own caching mechanism to know if a file need to be redownloaded because a new version is available 
        # For more detail, see: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control#caching_static_assets_with_cache_busting 
        static_use_hash = true;
      };

      /*
      # This allow to block settings in the preferences page accessible to user connecting to the searxng server
      preferences = {
        lock = [
          "autocomplete"
          "method"
        ];
      };
      */

      enabled_plugins = [
        "Hash plugin" # Allow to hash a string, for exemple this query: sha512 stringtohash
        "Self Informations" # Allow the query "ip" and "user agent" to show user information
        "Tracker URL remover" # Remove trackers arguments from the returned URL
        # "Ahmia blacklist" # Seem only useful when using the Tor network
        # "Hostnames plugin" # Rewrite hostnames, remove results or prioritize them based on the hostname
        # "Open Access DOI rewrite" # Avoid paywalls by redirecting to open-access versions of publications when available
      ];

      /*
      # External plugin to use (they must be installed first)
      # For more infos, see https://docs.searxng.org/dev/plugins.html#dev-plugin
      plugins = [
        "only_show_green_results"
      ];
      */
    };

    environmentFile = config.sops.secrets."searx".path;
  };

  sops.secrets."searx" = { };
}