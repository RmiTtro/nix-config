{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let 
  isMegasync = lib.lists.any (p: p == pkgs.megasync) config.home.packages;  
in lib.mkMerge [
  {
    home.packages = with pkgs; [ keepassxc ];
  } 

  
  (outputs.lib.addCopyOnChange config {
    xdg.configFile."keepassxc/keepassxc.ini".text = ''
      [SSHAgent]
      Enabled=true
    '';
  })
      
  (lib.mkIf isMegasync
    (outputs.lib.addCopyOnChange config {
      # This is to have my keepass bd configured to open as default
      # One of the field I need to set is usually serialized by QSettings, this is why the file need to be created by a python script
      home.file.".cache/keepassxc/keepassxc.ini".source = (pkgs.runCommand "keepassxc.ini" {
        nativeBuildInputs = [ (pkgs.python3.withPackages(ps: [ ps.pyqt6 ])) ];
        sourceRoot = ".";
        src = let
          databasePath="${config.home.homeDirectory}/MEGA/pass/rt_skull.kdbx";
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
    })
  )

  (lib.mkIf (isMegasync && config?sops)
    {
      sops.secrets."RT_SKULL.key" = {
        format = "binary";
        sopsFile = ./RT_SKULL.key;
      };
    }
  )
]