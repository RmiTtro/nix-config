{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.flatpak.enable = true;

  environment.persistence."/persistent" = {
    directories = [
      "/var/lib/flatpak"
    ];
  };
}