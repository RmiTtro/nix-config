{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # This is to allow "nix develop" to be run automatically for directories for which the following command has been run:
  #   echo "use flake" >> .envrc && direnv allow
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bash.enable = true;

  permanenceHomeWrap = {
    directories = [
      ".local/share/direnv"
    ];
  };
}
