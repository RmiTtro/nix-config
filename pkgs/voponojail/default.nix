{ writeShellApplication, vopono, firejailExecForVopono }: 
writeShellApplication {
  name = "voponojail";
  runtimeInputs = [ vopono firejailExecForVopono ];
  text = ''
    VOPONO_EXEC_COMMAND="$*" vopono exec firejailExecForVopono
  '';
}