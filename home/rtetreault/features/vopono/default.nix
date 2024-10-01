{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: lib.mkMerge [
  {
    home.packages = with pkgs; [ vopono openvpn ];
  }

  # Done this way since vopono does not like its config file to be readonly
  (outputs.lib.addCopyOnChange config {
    xdg.configFile."vopono/config.toml" = {
      text = ''
        provider = "nordvpn"
        server = "canada"
        # NordVPN DNS url retrived on https://support.nordvpn.com/hc/en-us/articles/19587726859793-What-are-the-addresses-of-my-NordVPN-DNS-servers
        dns = ["103.86.96.100", "103.86.96.100"]
      '';
      # Also have to remove the init file since vopono does not want any file to be readonly in its config directory
      removeInitFile = true;
    };
  })
]