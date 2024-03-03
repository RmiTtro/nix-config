{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "RmiTtro";
    userEmail = "tetreault.remi@gmail.com";
  };
}