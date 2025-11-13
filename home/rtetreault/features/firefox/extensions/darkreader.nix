profile:

{inputs, pkgs, ...}: {
  # TODO: add settings for dark reader extension
  programs.firefox.profiles.${profile}.extensions = {
    packages = with inputs.firefox-addons.packages."${pkgs.stdenv.hostPlatform.system}"; with pkgs.firefox-addons; [
      darkreader
    ];
  };
}