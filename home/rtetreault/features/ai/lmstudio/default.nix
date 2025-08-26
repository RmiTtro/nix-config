{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ lmstudio ];

  permanenceHomeWrap = {
    directories = [
      ".config/LM Studio"
      ".lmstudio"
    ];
  };
}