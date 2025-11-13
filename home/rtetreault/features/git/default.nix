{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  programs.git.settings.user = {
    name = "RmiTtro";
    email = "tetreault.remi@gmail.com";
  };

  permanenceHomeWrap = {
    directories = [
      "git"
    ];
  };
}
