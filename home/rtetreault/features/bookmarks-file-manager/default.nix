{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types literalExpression lists;
  inherit (lib.attrsets) attrVals hasAttrByPath;
  cfg = config.bookmarks-file-manager;
  availablesBookmarks = {
    downloads = "file:///home/rtetreault/Downloads Downloads";
    public = "file:///home/rtetreault/Public Public";
    mega = "file:///home/rtetreault/MEGA MEGA";
    filen = "file:///home/rtetreault/Filen Filen";
    git = "file:///home/rtetreault/git git";
    homeNetworkShare = "smb://desktop-lvv7t9v/public/ Home network share";
    bookmarkBreakpoint = "";
  };
in
{
  options.bookmarks-file-manager = {
    bookmarksSelection = mkOption {
      type = (types.listOf (types.enum (builtins.attrNames availablesBookmarks)));
      default = [];
      example = literalExpression ''[ "downloads" "public" ]'';
      description = ''
        Allow to select the bookmark that will appear in the file manager.
        The special bookmarkBreakpoint allow bookmarks before it to appear in the "My Computer" section of the side panel for file manager
        that have this possibility.
      '';
    };
  };
  
  config = mkMerge [
    (mkIf ((builtins.length cfg.bookmarksSelection) > 0) {
      gtk.enable = true;
      gtk.gtk3.bookmarks = 
        let 
          bookmarksKey = lists.remove "bookmarkBreakpoint" cfg.bookmarksSelection;
        in
        attrVals bookmarksKey availablesBookmarks;
        
      assertions = [
        {
          assertion = lists.all (x: (lists.count (y: y == x) cfg.bookmarksSelection) == 1) cfg.bookmarksSelection;
          message = "A bookmark must not be selected more than once.";
        }
      ];
    })
    
    (mkIf (((builtins.length cfg.bookmarksSelection) > 0) 
      && (hasAttrByPath ["programs" "nemo" "enable"] config) 
      && (config.programs.nemo.enable)) {
      programs.nemo.bookmark-separator = lists.findFirstIndex (elem: elem == "bookmarkBreakpoint") 0 cfg.bookmarksSelection;
    })
  ];
}