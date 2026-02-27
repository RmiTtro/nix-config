profile:

{config, ...}: {
  home.persistence."/persistent" = {
    directories = [
      {
        directory = ".mozilla/firefox/${profile}";
      }
    ];
  };
}