{ writeShellApplication, nodePackages_latest }:
writeShellApplication {
  name = "mywikiserver";
  runtimeInputs = [ nodePackages_latest.tiddlywiki ];
  text = ''
    BASE_PATH=~/MEGA/mytiddlywiki
    PORT=8088
    
    tiddlywiki $BASE_PATH --listen port=$PORT 
  '';
}
