{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ lmstudio ];

  home.persistence."/persistent" = {
    directories = [
      ".config/LM Studio"
      ".lmstudio"
    ];
  };
}