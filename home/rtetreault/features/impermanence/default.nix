{
  lib,
  config,
  pkgs,
  ...
}: {
  home.persistence."/persistent" = {
    hideMounts = true;
    allowTrash = true;

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
