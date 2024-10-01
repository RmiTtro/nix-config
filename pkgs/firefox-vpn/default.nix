{ writeShellApplication, writeScript, firefoxExecForVopono }: 
writeShellApplication {
  name = "firefox-vpn";
  runtimeInputs = [ firefoxExecForVopono ];
  text = ''
    vopono exec firefoxExecForVopono
  '';
}