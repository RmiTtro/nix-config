{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  systemd.user.services.mywikiserver = {
    Unit = {
      Description = "Start my TiddlyWiki on port 8088";
      PartOf = [ "default.target" ];
      AssertDirectoryNotEmpty="${config.home.homeDirectory}/MEGA/mytiddlywiki";
    };

    Service = {
      # For full lazy-load, use: $:/core/save/lazy-all
      # I only lazy-load images to still be able to search in the content of the tiddlers
      # I have read here that they will eventually implement on server search: https://tiddlywiki.com/dev/#LazyLoadingMechanism
      ExecStart = "${pkgs.nodePackages_latest.tiddlywiki}/bin/tiddlywiki ${config.home.homeDirectory}/MEGA/mytiddlywiki --listen host=0.0.0.0 port=8088 root-tiddler=$:/core/save/lazy-images";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}