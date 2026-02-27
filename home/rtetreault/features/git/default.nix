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

  home.persistence."/persistent" = {
    directories = [
      "git"
    ];
  };
}
