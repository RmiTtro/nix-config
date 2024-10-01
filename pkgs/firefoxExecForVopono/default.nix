{ writeShellApplication }: 
writeShellApplication {
  name = "firefoxExecForVopono";
  runtimeInputs = [ ];
  # firejail is needed to prevent a DNS leak has mentionned in https://github.com/jamesmcm/vopono/issues/89#issuecomment-1795045408
  text = ''
    firejail --noprofile --blacklist=/var/run/nscd/socket --netns="$VOPONO_NS" firefox -P "VPNProfile"
  '';
}