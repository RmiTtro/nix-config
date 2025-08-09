{
  lib,
  config,
  pkgs,
  ...
}: {
  permanenceHomeWrap = {
    enable = true;

    directories = [
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Public"
      "Templates"
      "Videos"
      ".gnupg"
      ".ssh"
      ".local/share/keyrings"
    ];
  };
}
