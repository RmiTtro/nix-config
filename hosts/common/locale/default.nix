{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    {
      # Set your time zone.
      time.timeZone = "America/Toronto";
    
      # Select internationalisation properties.
      i18n.defaultLocale = "en_CA.UTF-8";
    }
  
    (lib.mkIf config.services.xserver.enable {
      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };
    })
  ];
}