profile:

{config, ...}: {
  home.persistence."/persistent" = {
    directories = [
      {
        directory = ".config/mozilla/firefox/${profile}";
      }
    ];
  };
}