{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.readline = {
    enable = true;
    variables = {
      # Disable the bell sound that can be heard in multiples cases like searching a page search on Firefox without any match
      bell-style = "visible";
    };
  };
}