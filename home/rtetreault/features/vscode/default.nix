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
    "workbench.colorTheme" = "Default Dark Modern";
    "telemetry.telemetryLevel" = "off";
    "files.hotExit" = "off";

    # Everything below this comment is to disable Github Copilot integrations
    "accessibility.verbosity.inlineChat" = false;
    "accessibility.verbosity.panelChat" = false;
    "ansible.lightspeed.suggestions.waitWindow" = 360000;
    "chat.agent.enabled" = false;
    "chat.agent.maxRequests" = 0;
    "chat.commandCenter.enabled" = false;
    "chat.detectParticipant.enabled" = false;
    "chat.extensionTools.enabled" = false;
    "chat.focusWindowOnConfirmation" = false;
    "chat.implicitContext.enabled" = {
        "panel" = "never";
    };
    "chat.instructionsFilesLocations" = {
        ".github/instructions" = false;
    };
    "chat.mcp.discovery.enabled" = false;
    "chat.mcp.enabled" = false;
    "chat.modeFilesLocations" = {
        ".github/chatmodes" = false;
    };
    "chat.promptFiles" = false;
    "chat.promptFilesLocations" = {
        ".github/prompts" = false;
    };
    "chat.sendElementsToChat.attachCSS" = false;
    "chat.sendElementsToChat.attachImages" = false;
    "chat.sendElementsToChat.enabled" = false;
    "chat.setupFromDialog" = false;
    "chat.useFileStorage" = false;
    "dataWrangler.experiments.copilot.enabled" = false;
    "github.copilot.editor.enableAutoCompletions" = false;
    "github.copilot.editor.enableCodeActions" = false;
    "github.copilot.enable" = false;
    "github.copilot.nextEditSuggestions.enabled" = false;
    "github.copilot.renameSuggestions.triggerAutomatically" = false;
    "githubPullRequests.codingAgent.enabled" = false;
    "githubPullRequests.experimental.chat" = false;
    "gitlab.duoChat.enabled" = false;
    "inlineChat.holdToSpeech" = false;
    "inlineChat.lineNaturalLanguageHint" = false;
    "inlineChat.accessibleDiffView" = "off";
    "mcp" = {
        "inputs" = [];
        "servers" = {};
    };
    "notebook.experimental.generate" = false;
    "python.analysis.aiCodeActions" = {
        "convertFormatString" = false;
        "convertLambdaToNamedFunction" = false;
        "generateDocstring" = false;
        "generateSymbol" = false;
        "implementAbstractClasses" = false;
    };
    "python.experiments.enabled" = false;
    "remote.SSH.experimental.chat" = false;
    "telemetry.feedback.enabled" = false;
    "terminal.integrated.initialHint" = false;
    "workbench.editor.empty.hint" = "hidden";
  };

  programs.vscode.profiles.default.extensions = with inputs.nix-vscode-extensions.extensions."${pkgs.stdenv.hostPlatform.system}".vscode-marketplace; [
    jnoortheen.nix-ide
  ];

  permanenceHomeWrap = {
    directories = [
      ".config/Code/User"
    ];
  };
}