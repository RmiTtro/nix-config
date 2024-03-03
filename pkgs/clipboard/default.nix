{ writeShellApplication, xsel }:
writeShellApplication {
  name = "clipboard";
  runtimeInputs = [ xsel ];
  text = ''
    xsel -b
  '';
}
