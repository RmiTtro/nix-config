{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  # This script is in charge of creating a new empty root at boot
  # The old roots are backed up and get suppressed after some time
  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  environment.persistence."/persistent" = {
    enable = true;  # NB: Defaults to true, not needed
    hideMounts = true;

    # All specified directories are gonna be bind mount from the persistent directory to the specified location
    # Normally, it is not possible to send a file from these directories to the Trash, meaning we have to resort to permanently suppressing the file instead
    # Setting this option to true allow the trash fonctionality to be usable again
    # Do note that this work by creating a trash directory (.Trash-<uid>) in the bind mounted directory
    # This means that every directory we want to persist will have an hidden trash directory in its subdirectories 
    allowTrash = true;

    directories = [
      "/var/log"
      "/var/lib/power-profiles-daemon"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/timers"
      "/etc/ssh"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      { directory = "/var/db/sudo"; mode = "u=rwx,g=,o="; }
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}