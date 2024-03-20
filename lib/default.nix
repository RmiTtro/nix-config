{lib} : {
  # This function is to be used in home manager configs.
  # It add onChange attribute to file configs specified in home.file, xdg.configFile and xdg.dataFile and add a prefix to the specified file name.
  # The added onChange attribute have shell commands that create a writable copy of the linked file created by home manager. That copy has the specified name without the prefix.
  # This is useful for cases when you want program to be able to modify their configs files.
  addCopyOnChange = config: fileConfigs: let 
    inherit (lib.attrsets) mapAttrs mapAttrs' nameValuePair;
    inherit (lib.strings) splitString concatStringsSep;
    inherit (lib.lists) last init;
    addOnChange = basePath: (
      name: value: let
        filePath = name;
        splitedFilePath = splitString "/" filePath;
        fileName = last splitedFilePath;
        initFileName = "HomeManagerInit_" + fileName;
        initFilePath = concatStringsSep "/" ((init splitedFilePath) ++ [ initFileName ]);
      in
      if (fileName == "") || (value ? "onChange") then
        nameValuePair name value
      else nameValuePair
        (initFilePath)
        (value // {
          onChange = ''
            rm -f "${basePath}/${filePath}"
            cp "${basePath}/${initFilePath}" "${basePath}/${filePath}"
            chmod u+w "${basePath}/${filePath}"
          '';
        })
    );
    in
    mapAttrs (name: value:
      if name == "xdg" then (
        mapAttrs (name: value:
          if name == "configFile" then (
            mapAttrs' (addOnChange config.xdg.configHome) value
          ) 
          else if name == "dataFile" then (
            mapAttrs' (addOnChange config.xdg.dataHome) value
          )
          else value 
        ) value
      )
      else if name == "home" then (
        mapAttrs (name: value:
          if name == "file" then (
            mapAttrs' (addOnChange config.home.homeDirectory) value
          )  
          else value
        ) value
      )
      else value
    ) fileConfigs;
}