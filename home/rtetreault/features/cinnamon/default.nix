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

  home = {
    # xsession.enable must be at true or this won't work
    keyboard = {
      layout = "us,ca";
      variant = ",";
      options = [ "grp:alt_shift_toggle" ];
    };
  };
  
  xsession.enable = true;

  dconf = {
    enable = true;
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
}