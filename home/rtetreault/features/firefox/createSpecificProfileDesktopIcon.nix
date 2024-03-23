{pkgs, name, profile}:
{
  "Desktop/${profile}.desktop" = {
    source = (pkgs.runCommand "${profile}.desktop" 
      {
        src = "${pkgs.firefox}/share/applications/firefox.desktop"; 
        nativeBuildInputs = [ pkgs.initool ];
      } 
      ''
        initool set "$src" 'Desktop Entry' 'Exec' 'firefox %U -P "${profile}"' \
        | initool set - 'Desktop Entry' 'Name' '${name}' \
        | initool delete - 'Desktop Entry' 'Actions' \
        | initool delete - 'Desktop Action new-private-window' \
        | initool delete - 'Desktop Action new-window' \
        | initool delete - 'Desktop Action profile-manager-window' > "$out"
      ''
    );
    executable = true;
  };
}