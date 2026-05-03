{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  # This is this application: https://github.com/linuxmint/sticky
  home.packages = with pkgs; [ sticky ];

  # This is to autostart sticky with the notes visibles
  # sticky's autostart process is a bit peculiar so I will summarize it here:
  #   1. A desktop shortcut that execute the command `sticky --autostart` is placed in /etc/xdg/autostart at the installation of sticky
  #   2. The `--autostart` flag make sticky check in dconf the value of autostart. If it is false, the execution of sticky stop, else 
  #      sticky keep running.
  xdg.configFile."autostart/sticky.desktop".source = "${pkgs.copyq}/etc/xdg/autostart/sticky.desktop";
  dconf = {
    enable = true;
    settings."org/x/sticky".autostart = true;
    settings."org/x/sticky".autostart-notes-visible = true;
  };

  # This directory contain just one file: notes.json
  # I persist the containing directory because I had an issue where all my notes got deleted when I was just persisting the file and sticky was no longer opening
  # I'm hoping that by persisting the whole directory, I won't have this issue again 
  home.persistence."/persistent" = {
    directories = [
      ".config/sticky"
    ];
  };
}