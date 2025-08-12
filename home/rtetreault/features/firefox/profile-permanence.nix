profile:

{config, ...}: {
  permanenceHomeWrap = {
    directories = [
      {
        directory = ".mozilla/firefox/${profile}";
        ${if config.permanenceHomeWrap.isUsingHomeManagerModule then "method" else null} = "bindfs";
      }
    ];
  };
}