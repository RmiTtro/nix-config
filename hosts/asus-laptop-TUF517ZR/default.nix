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

    ./hardware-configuration.nix
    ./specialisation.nix
    ../common/nixos
    ../common/nixpkgs
    ../common/locale
    ../common/networking
    ../common/networking/connections/DERYtelecom_80114276
    ../common/networking/connections/DERYtelecom_80114276_5G
    ../common/networking/connections/DERYtelecom_80114276_EXT
    ../common/networking/connections/SM-S928W2301
    ../common/sound
    ../common/homeManagerModule
    ../common/users/rtetreault
    ../common/cinnamon
    ../common/sops-nix
    ../common/steam
    ../common/solaar
    ../common/samba
    ../common/printing
    ../common/opentablet
    ../common/searx
    ../common/firejail
    ../common/podman
  ];
  
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
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false; 

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

    # Allow to chose a specific driver version
    # package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Allow nvidia gpu to be used in container like podman or docker
  hardware.nvidia-container-toolkit.enable = true;

  services.asusd = {
    enable = true;
    enableUserService = true;
    package = pkgs-f89c670.asusctl;
  };
  environment.etc."asusd/asusd.ron" = {
    text = ''
      (
          charge_control_end_threshold: 80,
          panel_od: false,
          mini_led_mode: false,
          disable_nvidia_powerd_on_battery: true,
          ac_command: "",
          bat_command: "",
          platform_policy_linked_epp: true,
          platform_policy_on_battery: Quiet,
          platform_policy_on_ac: Performance,
          ppt_pl1_spl: None,
          ppt_pl2_sppt: None,
          ppt_fppt: None,
          ppt_apu_sppt: None,
          ppt_platform_sppt: None,
          nv_dynamic_boost: None,
          nv_temp_target: None,
      )
    '';
    mode = "0644";
  };
  programs.rog-control-center.enable = true;
  programs.rog-control-center.autoStart = true;
  

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

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
