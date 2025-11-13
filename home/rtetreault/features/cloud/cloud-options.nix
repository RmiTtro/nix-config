{lib, config, pkgs, ...}: let
  inherit (lib) mkOption types;
  cfg = config.cloud;
in  
{
  options.cloud = {
    enable = mkOption {
      type = types.uniq types.bool;
      default = false;
      description = ''
        When this setting is true, it mean a directory of the filesystem is synced with a cloud storage.
      '';
    };
    path = mkOption {
      type = types.uniq types.path;
      description = ''
        This the path of the local directory that is synced with cloud storage.
      '';
    };
  };
}