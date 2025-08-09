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
      ExecStart = "${pkgs.nodePackages_latest.tiddlywiki}/bin/tiddlywiki ${config.home.homeDirectory}/MEGA/mytiddlywiki --listen port=8088";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}