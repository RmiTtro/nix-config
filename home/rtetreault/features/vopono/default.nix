{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ vopono voponojail openvpn wireguard-tools ];

  # Done this way since vopono does not like its config file to be readonly
  addCopyOnChange.xdg.configFile."vopono/config.toml" = {
    text = ''
      provider = "Mullvad"
      protocol = "Wireguard"
      server = "canada"
    '';
    # Also have to place the init file elsewhere since vopono does not want any file to be readonly in its config directory
    initFileInSpecialDir = true;
  };

  permanenceHomeWrap = {
    directories = [
      ".config/vopono"
    ];
  };
}