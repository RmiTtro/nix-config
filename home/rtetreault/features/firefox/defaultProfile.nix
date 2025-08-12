profile:

{lib, ...}: {
  imports = [
    ./firefox.nix
    (import ./settings/commonSettings.nix profile)
  ];
  
  programs.firefox.profiles.${profile} = {
    isDefault = lib.mkDefault false;
    search.force = true;
    search.default = "ddg";
  };
}