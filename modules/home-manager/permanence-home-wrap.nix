# This Home-Manager module is mostly to keep the files and directories that need to be persisted from the home folder of the current user.
# If home-manager is used as a NixOS module, this information can be used to configure the the user section of the impermanence NixOS module with
# something like this:
#    environment.persistence."/persistent" = {
#      users.${username} = {
#        directories = config.home-manager.users.${username}.permanenceHomeWrap.directories;
#        files = config.home-manager.users.${username}.permanenceHomeWrap.files;
#      };
#    };
# If instead, Home-Manager is used independently, the impermanence Home-Manager module will automaticaly configured using the information provided to this module
{inputs, lib, config, pkgs, ...}@args:
let
  isUsingHomeManagerModule = !args?osConfig;
  inherit (lib) optional optionalAttrs mkEnableOption mkOption mkMerge types literalExpression;
  cfg = config.permanenceHomeWrap;
in
{
  imports = optional isUsingHomeManagerModule inputs.impermanence.homeManagerModules.impermanence;

  options.permanenceHomeWrap = {
    enable = mkEnableOption "permanenceHomeWrap";
    files = mkOption {
      type = types.listOf types.anything;
      default = [];
      example = literalExpression ''[  
        ".config/cinnamon-monitors.xml"
      ]'';
      description = "Path to the files to persist relative to the home directory of the current user.";
    };
    directories = mkOption {
      type = types.listOf types.anything;
      default = [];
      example = literalExpression ''[  
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
      ]'';
      description = "Path to the directories to persist relative to the home directory of the current user.";
    };
    isUsingHomeManagerModule = mkOption {
      type = types.uniq types.bool;
      description = "A readonly option that is set to true when the Impermanence home-manager module is used.";
    };
  };

  config = {
    permanenceHomeWrap.isUsingHomeManagerModule = isUsingHomeManagerModule;
  } // optionalAttrs isUsingHomeManagerModule {
    home.persistence = {
      "/persistent/${config.home.homeDirectory}" = {
        # symlink by default, use bindfs only for dir that must also contain config files managed by home-manager
        defaultDirectoryMethod = "symlink";
      
        directories = cfg.directories;
        files = cfg.files;
        
        allowOther = true;
      };
    };
  };
}