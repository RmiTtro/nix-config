{lib} : {
  # This is for conditional assignment in attribute set
  # Use like this: { ${assignIfAttrOf(config.home, "persistence")} = {etc...} }
  assignIfAttrOf = o: attr: (if (lib.hasAttr attr o) then attr else null);


  # This function is to be used in home manager configs.
  # It add onChange attribute to file configs specified in home.file, xdg.configFile and xdg.dataFile and add a prefix to the specified file name.
  # The added onChange attribute have shell commands that create a writable copy of the linked file created by home manager. That copy has the specified name without the prefix.
  # This is useful for cases when you want program to be able to modify their configs files.
  # This function also support a new attribute in file configs named initFileInSpecialDir that place the link to the file created by home manager in a different directory than the one specified.
  # The link will instead be placed in a directory named HomeManagerInit that will be at the root of the directory represented by the used option (ex: for home.file, the root directory is config.home.homeDirectory).
  # Note that asside of being placed in the HomeManagerInit directory, the rest of the path is preserved. This attribute can be useful for rare case where a program does not want any readonly file in its config directory.
  addCopyOnChange = config: fileConfigs: let 
    inherit (lib.attrsets) mapAttrs mapAttrs' nameValuePair optionalAttrs;
    inherit (lib.strings) splitString concatStringsSep optionalString;
    inherit (lib.lists) last init optional;
    inherit (lib) removeAttrs;
    addOnChange = basePath: (
      name: value: let
        isTarget = value ? "target";
        isInitFileInSpecialDir = value.initFileInSpecialDir or false;
        filePath = if isTarget then value.target else name;
        splitedFilePath = splitString "/" filePath;
        fileName = last splitedFilePath;
        initFileName = "HomeManagerInit_" + fileName;
        initFilePath = concatStringsSep "/" ((optional isInitFileInSpecialDir "HomeManagerInit") ++ (init splitedFilePath) ++ [ initFileName ]);
      in
      if (fileName == "") || (value ? "onChange") then
        nameValuePair name value
      else 
        nameValuePair
          (if isTarget then name else initFilePath)
          (
            (removeAttrs value [ "initFileInSpecialDir" ]) 
            // {
              onChange = ''
                rm -f '${basePath}/${filePath}'
                mkdir -p "$(dirname '${basePath}/${filePath}')"
                cp '${basePath}/${initFilePath}' '${basePath}/${filePath}'
                chmod u+w '${basePath}/${filePath}'
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