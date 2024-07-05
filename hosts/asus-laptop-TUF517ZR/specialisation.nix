{ config, lib, pkgs, ... }:

{
  specialisation = {
    offload-mode.configuration = {
      system.nixos.tags = [ "offload-mode" ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce true;
        prime.offload.enableOffloadCmd = lib.mkForce true;
        prime.sync.enable = lib.mkForce false;
      };
    };
  };
}
