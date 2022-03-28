{ config, lib, pkgs, ... }:
{
  boot.initrd.luks.devices = {
    LUKS-BIRDPERSON-ROOT = {
      device = "/dev/disk/by-partlabel/BIRDPERSON-ROOT";
      allowDiscards = true;
    };

    LUKS-BIRDPERSON-ROOT-2 = {
      device = "/dev/disk/by-partlabel/BIRDPERSON-ROOT-2";
      allowDiscards = true;
    };


    LUKS-BIRDPERSON-ARCHIVES = {
      device = "/dev/disk/by-partlabel/BIRDPERSON-ARCHIVES";
      allowDiscards = true;
    };

  };



  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/archives" =
    { device = "/dev/disk/by-label/archives";
      fsType = "ext4";
    };


  fileSystems."/boot" =
    { device = "/dev/disk/by-partlabel/EFI-BIRDPERSON";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];
}
