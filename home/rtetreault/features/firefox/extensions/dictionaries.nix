profile:

{inputs, pkgs, ...}: {
  programs.firefox.profiles.${profile}.extensions = {
    packages = with inputs.firefox-addons.packages."${pkgs.system}"; with pkgs.firefox-addons; [
      french-dictionary
      canadian-english-dictionary
    ];
  };
}