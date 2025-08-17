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
    outputs.homeManagerModules.preferredApplications

    ./features/cudatext
    ./features/geany
    ./features/pyp
    ./features/nomacs
    ./features/firefox/standardProfile
    ./features/firefox/secureProfile
    ./features/firefox/tiddlywikiProfile
    ./features/firefox/vpnProfile
    ./features/copyq
    ./features/git
    ./features/megasync
    ./features/megasync/nemo
    ./features/shutter
    ./features/clipboard
    ./features/mywikiserver
    ./features/keepassxc
    ./features/bash
    ./features/fonts
    ./features/powerline-go
    ./features/cinnamon
    ./features/bookmarks-file-manager
    ./features/vscode
    ./features/krita
    ./features/vlc
    ./features/vopono
    ./features/impermanence
    ./features/sops-nix
    ./features/rog-control-center
    ./features/games
    ./features/qbittorrent
    ./features/fhs
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
  
  preferred.applications = {
    enable = true;
    music = "vlc";
    video = "vlc";
    photos = "org.nomacs.ImageLounge";
    pdf = "xreader";
    sourceCode = "cudatext";
    fileManager = "nemo";
    plainText = "cudatext";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}