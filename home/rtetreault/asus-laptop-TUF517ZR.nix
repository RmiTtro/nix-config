# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  username, home
}:

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    ./features/cudatext
    ./features/geany
    ./features/pyp
    ./features/nomacs
    ./features/firefox/standardProfile
    ./features/firefox/secureProfile
    ./features/copyq
    ./features/git
    ./features/megasync
    ./features/megasync/nemo
    ./features/shutter
    ./features/clipboard
    ./features/mywikiserver
    ./features/keepassxc
    ./features/bash
    ./features/cinnamon
    ./features/bookmarks-file-manager
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = builtins.attrValues outputs.overlays;  
    
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = username;
    homeDirectory = home;
  };

  # Enable home-manager
  programs.home-manager.enable = true;
 
  bookmarks-file-manager.bookmarksSelection = [
    "downloads"
    "public"
    "bookmarkBreakpoint"
    "git"
    "mega"
    "homeNetworkShare"
  ];
  

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}