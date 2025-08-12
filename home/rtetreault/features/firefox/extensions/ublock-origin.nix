profile:

{inputs, pkgs, ...}: {
  # TODO: add settings for ublock origin extension
  programs.firefox.profiles.${profile}.extensions = {
    packages = with inputs.firefox-addons.packages."${pkgs.system}"; with pkgs.firefox-addons; [
      ublock-origin
    ];
  };
}