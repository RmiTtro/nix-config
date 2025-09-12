{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ vopono voponojail openvpn ];

  # Done this way since vopono does not like its config file to be readonly
  addCopyOnChange.xdg.configFile."vopono/config.toml" = {
    text = ''
      provider = "NordVPN"
      server = "canada"
      # NordVPN DNS url retrived on https://support.nordvpn.com/hc/en-us/articles/19587726859793-What-are-the-addresses-of-my-NordVPN-DNS-servers
      dns = ["103.86.96.100", "103.86.96.100"]
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