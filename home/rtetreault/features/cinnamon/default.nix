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
  };
  
  # Override system Nemo so we can add plugins
  programs.nemo.enable = true;
}