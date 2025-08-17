{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    powerline-go-fhs

    # Come from https://nixos-and-flakes.thiscute.world/best-practices/run-downloaded-binaries-on-nixos
    # This is to allow to provide an env to run binary not packaged for Nix
    # To use, just run this command: fhs
    ## This will open a shell in the typical linux filesystem
    ## You now just have to execute your program
    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSEnv (base // {
      name = "fhs";
      targetPkgs = pkgs: 
        # pkgs.buildFHSEnv provides only a minimal FHS environment,
        # lacking many basic packages needed by most software.
        # Therefore, we need to add them manually.
        #
        # pkgs.appimageTools provides basic packages required by most software.
        (base.targetPkgs pkgs) ++ (with pkgs; [
          # Feel free to add more packages here if needed.
        ]
      );
      profile = "export FHS=1";
      runScript = "bash";
      extraOutputsToInstall = ["dev"];
    }))
  ];

  # Add a custom module to powerline-go to show when we are under FHS
  # powerline-go is going to call my custom command: powerline-go-fhs
  programs.powerline-go.modules = [ "fhs" ];

  # The evil directory is where I plan to put everything that I'm going to execute with fhs
  # The evil name is because it is not how thing are ment to be done in NixOS
  permanenceHomeWrap = {
    directories = [
      "evil"
    ];
  };
}