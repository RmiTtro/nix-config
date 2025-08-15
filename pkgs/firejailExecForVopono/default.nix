{ writeShellApplication }: 
writeShellApplication {
  name = "firejailExecForVopono";
  # no firejail in the runtimeInputs, we use the one provided by the host 
  runtimeInputs = [ ];
  # firejail is needed to prevent a DNS leak has mentionned in https://github.com/jamesmcm/vopono/issues/89#issuecomment-1795045408
  text = ''
    # shellcheck disable=SC2086
    firejail --noprofile --blacklist=/var/run/nscd/socket --netns="$VOPONO_NS" $VOPONO_EXEC_COMMAND
  '';
}