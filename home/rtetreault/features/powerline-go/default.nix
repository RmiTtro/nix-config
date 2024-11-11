{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: lib.mkMerge [
  {  
    # Allow terminal prompt to show some informations
    programs.powerline-go.enable = true;
    # Use the default list of modules with nix-shell added
    programs.powerline-go.modules = [ 
      "nix-shell"
      "venv"
      "user"
      "host"
      "ssh"
      "cwd"
      "perms"
      "git"
      "hg"
      "jobs"
      "exit"
      "root" 
    ];
  }

  # If fonts are handled by home-manager, we install the powerline fonts and use the improved UI
  (lib.mkIf config.fonts.fontconfig.enable {
    programs.powerline-go.settings."mode" = "patched";

    # Necessary or some symbols are not shown in the prompt
    # https://www.reddit.com/r/NixOS/comments/16i7bc0/how_to_install_powerline_and_fontawesome/
    # Also require the symbol package from nerd font which is installed in the fonts directory
    home.packages = with pkgs; [
      powerline-fonts 
      powerline-symbols 
    ];
  })

  # If fonts are not handled by home-manager, we just use a mode that doesn't need the additionals symbols
  (lib.mkIf (!config.fonts.fontconfig.enable) {
    programs.powerline-go.settings."mode" = "compatible";
  })
]