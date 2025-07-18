{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # This allow software like keymapp or wally-cli to access my moonlander keyboard in userland
  hardware.keyboard.zsa.enable = true;

  environment.systemPackages = with pkgs; [
    wally-cli
  ];
}