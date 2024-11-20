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

  programs.vscode.userSettings = {
    "workbench.colorTheme" = "Default Dark Modern";
    "telemetry.telemetryLevel" = "off";
    "files.hotExit" = "off";
  };

  programs.vscode.extensions = with inputs.nix-vscode-extensions.extensions."${pkgs.system}".vscode-marketplace; [
    jnoortheen.nix-ide
  ];
}