{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-9da7f1c,
  ...
}: 

lib.mkMerge [
  {
    # TODO: Get back to using the most recent version of KeepassXC once version 2.7.12 is on NixPkgs
    # Use the previous version of KeepassXC since the most current one (2.7.11) has a bug that prevent autotype from working on Linux
    # See: https://github.com/keepassxreboot/keepassxc/issues/12723 for more infos
    home.packages = with pkgs-9da7f1c; [ keepassxc ];
    addCopyOnChange.xdg.configFile."keepassxc/keepassxc.ini".text = ''
      [SSHAgent]
      Enabled=true

      [GUI]
      ApplicationTheme=dark
    '';
  }
      
  (lib.mkIf (config.cloud.enable && config.sops.enable)
    {
      # This is to have my keepass bd configured to open as default
      # One of the field I need to set is usually serialized by QSettings, this is why the file need to be created by a python script
      addCopyOnChange.home.file.".cache/keepassxc/keepassxc.ini".source = (pkgs.runCommand "keepassxc.ini" {
        nativeBuildInputs = [ (pkgs.python3.withPackages(ps: [ ps.pyqt6 ])) ];
        sourceRoot = ".";
        src = let
          databasePath="${config.cloud.path}/pass/rt_skull.kdbx";
          keyPath=config.sops.secrets."RT_SKULL.key".path;
        in pkgs.writeTextFile {
          name = "createKeepassxcIni.py";
          text = ''
            from PyQt6.QtCore import QSettings
            settings = QSettings('keepassxc.ini', QSettings.Format.IniFormat)
            settings.setValue('LastActiveDatabase', '${databasePath}')
            settings.setValue('LastDatabases', '${databasePath}')
            settings.setValue('LastKeyFiles',{'${databasePath}': '${keyPath}'})
            settings.setValue('LastOpenedDatabases', '${databasePath}')
            settings.sync()
          '';
        };
      } ''
        python3 $src
        cp keepassxc.ini $out
      '');

      sops.secrets."RT_SKULL.key" = {
        format = "binary";
        sopsFile = ./RT_SKULL.key;
      };
    }
  )
]