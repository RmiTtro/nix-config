{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let 
  inherit (outputs.lib) assignIfAttrOf;
in {
  # To login: sudo tailscale up
  # To login with auth key: sudo tailscale up --auth-key=KEY
  services.tailscale.enable = true;

  environment.${assignIfAttrOf config.environment "persistence"}."/persistent" = {
    directories = [
      "/var/lib/tailscale"
    ];
  };
}