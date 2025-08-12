profile:

{...}:
{
  programs.firefox.profiles."${profile}".search.engines = {
    nixos-options = {
      name = "NixOS options";
      urls = [{ template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}"; }];
      icon = "https://search.nixos.org/favicon.png";
      definedAliases = [ "!nixopt" ];
    };

    home-manager-option-search = {
      name = "Home manager Option search";
      urls = [{ template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master"; }];
      icon = "https://home-manager-options.extranix.com/images/favicon.png";
      definedAliases = [ "!homemanager" "!home-manager" ];
    };
  };
}