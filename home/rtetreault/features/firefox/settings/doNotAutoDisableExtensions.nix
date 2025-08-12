profile:

{lib, ...}: { 
  programs.firefox.profiles.${profile}.settings = lib.mkDefault {
    "extensions.autoDisableScopes" = 0; # This prevent all extensions installed by nix to be disabled
  };
}