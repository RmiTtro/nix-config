{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;

    languagePacks = [
      "en-CA"
      "fr"
    ];

    # The default config path is no longer ./mozilla/firefox
    # A warning displayed based on the stateVersion said that to use the new path, the change had to be specified manually
    # with the migration also done manually
    # In other words, I must keep this here even if it is the new default since the old default is still in effect because of my stateVersion
    # I might be able to remove this line in future version of home-manager, once the warning is removed
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };
}