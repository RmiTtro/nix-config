# This helper module is for adding onChange attribute to file configs specified in home.file, xdg.configFile and xdg.dataFile while also adding a prefix to the specified file name.
# The added onChange attribute have shell commands that create a writable copy of the linked file created by home manager. That copy has the specified name without the prefix.
# This is useful for cases when you want program to be able to modify their configs files.
# This module also support a new attribute in file configs named initFileInSpecialDir that place the link to the file created by home manager in a different directory than the one specified.
# The link will instead be placed in a directory named HomeManagerInit that will be at the root of the directory represented by the used option (ex: for home.file, the root directory is config.home.homeDirectory).
# Note that asside of being placed in the HomeManagerInit directory, the rest of the path is preserved. This attribute can be useful for rare case where a program does not want any readonly file in its config directory.
{outputs, lib, config, pkgs, ...}: let
  inherit (lib) mkOption types;
  cfg = config.addCopyOnChange;
in  
{
  options.addCopyOnChange = {
    xdg.configFile = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      description = ''
        Use this option as you would `xdg.configFile` but do note that if you provide an `onChange` 
        attribute the config will be passed to `xdg.configFile` without modifications.
      '';
    };
    xdg.dataFile = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      description = ''
        Use this option as you would `xdg.dataFile` but do note that if you provide an `onChange` 
        attribute the config will be passed to `xdg.dataFile` without modifications.
      '';
    };
    home.file = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      description = ''
        Use this option as you would `home.file` but do note that if you provide an `onChange` 
        attribute the config will be passed to `home.file` without modifications.
      '';
    };
  };

  config = let
    modifiedCfg = (outputs.lib.addCopyOnChange config cfg);
  in {
    xdg = modifiedCfg.xdg;
    home = modifiedCfg.home;
  };
}