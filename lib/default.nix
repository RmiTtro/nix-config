{lib} : {
  # This function is to be used in home manager configs.
  # It add onChange attribute to file configs specified in home.file, xdg.configFile and xdg.dataFile and add a prefix to the specified file name.
  # The added onChange attribute have shell commands that create a writable copy of the linked file created by home manager. That copy has the specified name without the prefix.
  # This is useful for cases when you want program to be able to modify their configs files.
  # This function also support a new attribute in file configs named removeInitFile that allow to delete the link to the file create by home manager after
  # the writtable copy is created. This can be useful for rare case where a program does not want any readonly file in its directory.
  addCopyOnChange = config: fileConfigs: let 
    inherit (lib.attrsets) mapAttrs mapAttrs' nameValuePair optionalAttrs;
    inherit (lib.strings) splitString concatStringsSep optionalString;
    inherit (lib.lists) last init;
    inherit (lib) removeAttrs;
    addOnChange = basePath: (
      name: value: let
        isTarget = value ? "target";
        filePath = if isTarget then value.target else name;
        splitedFilePath = splitString "/" filePath;
        fileName = last splitedFilePath;
        initFileName = "HomeManagerInit_" + fileName;
        initFilePath = concatStringsSep "/" ((init splitedFilePath) ++ [ initFileName ]);
        isRemoveInitFile = (value ? "removeInitFile") && value.removeInitFile;
      in
      if (fileName == "") || (value ? "onChange") then
        nameValuePair name value
      else nameValuePair
        (if isTarget then name else initFilePath)
        (
          (removeAttrs value [ "removeInitFile" ]) 
          // {
            onChange = ''
              rm -f '${basePath}/${filePath}'
              cp '${basePath}/${initFilePath}' '${basePath}/${filePath}'
              chmod u+w '${basePath}/${filePath}'
            '' + optionalString isRemoveInitFile ''
              rm -f '${basePath}/${initFilePath}'
            '';
          } 
          // (optionalAttrs isTarget {target=initFilePath;})
        )
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