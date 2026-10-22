# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-f89c670,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    inputs.hardware.nixosModules.common-gpu-nvidia
    # Use this one if you plan to use the mux switch to have the dGPU control the laptop monitor directly
    #inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    # Not using disko since I want to keep the windows recovery partition and it is not possible with disko
    # inputs.disko.nixosModules.disko
    # (import ./disko.nix { device = "/dev/nvme0n1"; })
    ./hardware-configuration.nix
    ./specialisation.nix
    ../common/nixos
    ../common/nixpkgs
    ../common/locale
    ../common/networking
    ../common/networking/connections/VIRGIN513
    ../common/networking/connections/SM-S928W2301
    ../common/sound
    ../common/homeManagerModule
    ../common/users/rtetreault
    ../common/cinnamon
    ../common/sops-nix/active.nix
    ../common/steam
    ../common/solaar
    ../common/samba
    ../common/printing
    ../common/opentablet
    ../common/searx
    ../common/firejail
    ../common/podman
    ../common/zsa
    ../common/impermanence/active.nix
    ../common/tailscale
    # TODO: uncomment this when the virtualbox package is fixed
    # I commented virtualbox since the package was broken last time I was doing an update
    # I didn't bother using a previous version since I'm currently not using virtualbox
    #../common/virtualbox
    ../common/flatpak
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  
  # Make the generated xorg.conf file accessible in /etc/X11
  services.xserver.exportConfiguration = true;

  hardware.nvidia = {
  
  
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
  
    prime = {
      offload = {
        enable = false;
        enableOffloadCmd = false;
      };
      
      sync.enable = true;
      reverseSync.enable = false; # TODO: Use this mode when it is no longer experimental 
      allowExternalGpu = false;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # This to stop screen tearing as suggested on https://christitus.com/fix-screen-tearing-linux/
    forceFullCompositionPipeline = true;

    # Allow to chose a specific driver version
    # package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Allow nvidia gpu to be used in container like podman or docker
  hardware.nvidia-container-toolkit.enable = true;

  services.asusd = {
    enable = true;

    asusdConfig.text = ''
      (
        charge_control_end_threshold: 80,
        base_charge_control_end_threshold: 80,
        disable_nvidia_powerd_on_battery: true,
        ac_command: "",
        bat_command: "",
        platform_profile_linked_epp: true,
        platform_profile_on_battery: Quiet,
        change_platform_profile_on_battery: true,
        platform_profile_on_ac: Performance,
        change_platform_profile_on_ac: true,
        profile_quiet_epp: Power,
        profile_balanced_epp: BalancePower,
        profile_custom_epp: Performance,
        profile_performance_epp: Performance,
        ac_profile_tunings: {
            Performance: (
                enabled: false,
                group: {},
            ),
        },
        dc_profile_tunings: {},
        armoury_settings: {},
      )
    '';

    # I specify this config just so that the keyboard backlight is off by default
    auraConfigs.tuf.text = ''
      (
        config_name: "aura_tuf.ron",
        brightness: Off,
        current_mode: Static,
        builtins: {
            Static: (
                mode: Static,
                zone: r#None,
                colour1: (
                    r: 166,
                    g: 0,
                    b: 0,
                ),
                colour2: (
                    r: 0,
                    g: 0,
                    b: 0,
                ),
                speed: Med,
                direction: Right,
            ),
            Breathe: (
                mode: Breathe,
                zone: r#None,
                colour1: (
                    r: 166,
                    g: 0,
                    b: 0,
                ),
                colour2: (
                    r: 0,
                    g: 0,
                    b: 0,
                ),
                speed: Med,
                direction: Right,
            ),
            Pulse: (
                mode: Pulse,
                zone: r#None,
                colour1: (
                    r: 166,
                    g: 0,
                    b: 0,
                ),
                colour2: (
                    r: 0,
                    g: 0,
                    b: 0,
                ),
                speed: Med,
                direction: Right,
            ),
        },
        multizone_on: false,
        enabled: (
            states: [
                (
                    zone: Keyboard,
                    boot: true,
                    awake: true,
                    sleep: true,
                    shutdown: true,
                ),
            ],
        ),
      )
    '';
  };

  programs.rog-control-center.enable = true;
  # TODO: use the autoStart option when it is fixed
  # The logic behind the autoStart option does account for the prefix that was added to the .desktop file
  # This is the reason that I'm doing it here manually
  # programs.rog-control-center.autoStart = true;
  environment.systemPackages = with pkgs; [
    (pkgs.makeAutostartItem {
      name = "rog-control-center";
      srcPrefix = "org.opengamingcollective.";
      package = pkgs.asusctl;
    })
  ];
  

  # Bootloader.
  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };
  boot.supportedFilesystems = [ "ntfs" ];
  boot.initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/76232609-5d76-4412-aee4-2aadd3275d14";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11"; # Did you read the comment?
}
