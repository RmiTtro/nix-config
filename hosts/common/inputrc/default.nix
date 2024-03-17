{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # The default /etc/inputrc file come from the bash module
  # We keep using this default file, with the only difference that we change the bell-style
  # This modification is to disable the bell sound that can be heard in multiples cases like when a page search on Firefox don't have any match
  environment.etc.inputrc.source = pkgs.runCommandLocal "inputrc" {} ''
    cp "${inputs.nixpkgs.outPath}/nixos/modules/programs/bash/inputrc" $out
    substituteInPlace $out --replace "set bell-style none" "set bell-style visible"
  '';
}