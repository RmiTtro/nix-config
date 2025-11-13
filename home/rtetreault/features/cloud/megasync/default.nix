{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  megasync = pkgs.megasync;
in
{
  imports = [ ../cloud-options.nix ];

  cloud.enable = true;
  cloud.path = "${config.home.homeDirectory}/MEGA";

  # Use autostart instead of systemd since systemd make a window appear instead of doing a silent start
  # I think the reason it does that is because the systemd unit is executed too early during desktop environnment init phase
  # I could not find a systemd target that was performed far enough to not cause these issues (xdg-desktop-autostart.target might work)
  #services.megasync.enable = true;
  
  home.packages = [ megasync ];
  
  xdg.configFile."autostart/megasync.desktop".source = "${megasync}/share/applications/megasync.desktop";

  permanenceHomeWrap = {
    directories = [
      "MEGA"
      "MEGAsync Downloads"
      ".local/share/data/Mega Limited/MEGAsync"
    ];
  };
}
