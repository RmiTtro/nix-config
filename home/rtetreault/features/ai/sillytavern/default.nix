{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: { 
  config = {
    home.packages = with pkgs; [ sillytavern ];

    home.shellAliases = {
      # The global flag make it save its data in the ~/.local/share/SillyTavern/ directory 
      "sillytavern" = "sillytavern --global";
    };

    permanenceHomeWrap = {
      directories = [
        ".local/share/SillyTavern"
      ];
    };

    sops.secrets = {
      "sillytavern_secrets" = {
        path = "${config.home.homeDirectory}/.local/share/SillyTavern/data/default-user/secrets.json";
      };
    };
  };
}