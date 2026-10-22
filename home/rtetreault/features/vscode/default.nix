# Note: For all my projects, I plan to have a flake that will instantiate a version of vscode specific for the project. This will allow
# a project to have a version of vscode with only the extensions required for the project.
# This current file serve 2 purposes:
#   1 - Configure a global version of vscode (not specific to a project)
#   2 - Configure the users settings that will apply to every version of vscode 

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.vscode.enable = true;

  programs.vscode.profiles.default.userSettings = {
    "chat.disableAIFeatures" = true;
    "extensions.autoCheckUpdates" = false;
    "extensions.autoUpdate" = "off";
    "files.hotExit" = "off";
    "telemetry.telemetryLevel" = "off";
    "update.mode" = "none";
    "workbench.colorTheme" = "Dark Modern";
  };

  programs.vscode.profiles.default.extensions = with inputs.nix-vscode-extensions.extensions."${pkgs.stdenv.hostPlatform.system}".vscode-marketplace; [
    jnoortheen.nix-ide
  ];

  home.persistence."/persistent" = {
    directories = [
      # Where workspaces are saved
      ".config/Code/User"
      # Where trusted folders are saved
      ".vscode-shared/sharedStorage"
    ];
  };
}