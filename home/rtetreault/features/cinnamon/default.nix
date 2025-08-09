{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    outputs.homeManagerModules.nemo
  ];

  # I don't make home-manager manage the xsession since it cause me a lot of issues, especially with autostarting app
  # xsession.enable = true;

  home = {
    # xsession.enable must be at true or this won't work
    # Not used since I had problems with xsession.enable
    # Instead, this is configured by dconf
    /*
    keyboard = {
      layout = "us,ca";
      options = [ "grp:alt_shift_toggle" ];
    };
    */
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  dconf = {
    enable = true;

    # This match Keyboard > Layouts
    settings."org/gnome/libgnomekbd/keyboard".layouts = ["us" "ca"];
    settings."org/gnome/libgnomekbd/keyboard".options = ["grp\tgrp:alt_shift_toggle"];

    # settings."org/gnome/desktop/interface".color-scheme = "prefer-dark"; # Come from https://nixos.wiki/wiki/GNOME
    settings."org/x/apps/portal".color-scheme = "prefer-dark"; # Come from a search of color-scheme in dconf-editor
    
    # This match Themes > Advanced settings... > Applications 
    settings."org/cinnamon/desktop/interface".gtk-theme = "Mint-Y-Dark";
    settings."org/gnome/desktop/interface".gtk-theme = "Mint-Y-Dark";
    
    # Not necessary, this is just for it to appear in the Keyboard settings gui
    settings."org/cinnamon/settings-daemon/peripherals/keyboard".input-sources-switcher = "alt-shift";
    
    # This match Windows > Behavior > Moving and Resizing Windows > Special key to move and resize windows
    settings."org/cinnamon/desktop/wm/preferences".mouse-button-modifier = "<Super>";
    settings."org/gnome/desktop/wm/preferences".mouse-button-modifier = "<Super>";

    # Turn off the sounds
    settings."org/cinnamon/sounds".login-enabled = false;
    settings."org/cinnamon/sounds".logout-enabled = false;
    settings."org/cinnamon/sounds".notification-enabled = false;
    settings."org/cinnamon/sounds".plug-enabled = false;
    settings."org/cinnamon/sounds".switch-enabled = false;
    settings."org/cinnamon/sounds".tile-enabled = false;
    settings."org/cinnamon/sounds".unplug-enabled = false;
    
    # Attempt at disabling annoying beeping sound made by some applications
    # Come from:
    #   - https://github.com/linuxmint/cinnamon/issues/5253
    #   - https://wiki.archlinux.org/title/PC_speaker
    settings."org/cinnamon/settings-daemon/peripherals/keyboard".bell-mode = "off";
    settings."org/gnome/desktop/wm/preferences".audible-bell = false;
    settings."org/cinnamon/desktop/wm/preferences".audible-bell = false;
  };
  
  # Attempt at disabling annoying beeping sound made by some applications
  # Come from:
  #   - https://wiki.archlinux.org/title/PC_speaker
  gtk.enable = true;
  gtk.gtk2.extraConfig = "gtk-error-bell = 0";
  gtk.gtk3.extraConfig = { "gtk-error-bell" = 0; };
  
  # Override system Nemo so we can add plugins
  programs.nemo.enable = true;

  permanenceHomeWrap = {
    files = [
      ".config/cinnamon-monitors.xml" # Display config is in that file
    ];

    directories = [
      ".config/cinnamon/spices/grouped-window-list@cinnamon.org" # What is added to the task bar is kept somewhere in the file of this directory
      ".local/share/gvfs-metadata" # I keep this because change to folder icon is kept in there
    ];
  };
}
