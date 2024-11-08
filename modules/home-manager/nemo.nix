{lib, config, pkgs, ...}:
let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types literalExpression;
  cfg = config.programs.nemo;
in
{
  options = {
    programs.nemo = {
      enable = mkEnableOption "Nemo";
      
      plugins = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExpression "[ pkgs.megashellextnemo ]";
        description = "List of plugins to include with the Nemo file manager.";
      };
      
      bookmark-separator = mkOption {
        type = types.int;
        default = -1;
        example = literalExpression "2";
        description = ''
          For the bookmarks configured by the option `gtk.gtk3.bookmarks`, specify the number that must be below the "My Computer" section of the side panel. The following value are accepted:
            - -1 : make all the bookmarks appear in the "My Computer" section
            -  0 : make all the bookmarks appear in the "Bookmarks" section
            -  n : make the n bookmarks appear in the "My Computer" section and the rest in the "Bookmarks" section
        '';
      };
    };
  };
  
  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ 
        (pkgs.nemo-with-extensions.override { extensions = cfg.plugins; })  
      ];
    })
    
    (mkIf (cfg.enable && config.gtk.enable) {
      dconf = {
        settings."org/nemo/window-state".sidebar-bookmark-breakpoint = cfg."bookmark-separator";
      };
      
      assertions = [
        {
          assertion = cfg."bookmark-separator" > -1;
          message = "The value ${cfg.bookmark-separator} is not a valid value for the bookmark-separator option.";
        }
        {
          assertion = cfg."bookmark-separator" <= (builtins.length config.gtk.gtk3.bookmarks);
          message ="The value ${cfg.bookmark-separator} of the option bookmark-separator is above the number of gtk3 bookmarks ${builtins.length config.gtk.gtk3.bookmarks}";
        }
      ];
    })
  ];
}