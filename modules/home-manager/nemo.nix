{lib, config, pkgs, ...}:
let
  inherit (lib) mkEnableOption mkOption mkIf types literalExpression;
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
    };
  };
  
  config = mkIf cfg.enable {
    home.packages = [ 
      (pkgs.cinnamon.nemo-with-extensions.override { extensions = cfg.plugins; })  
    ];
  };
}