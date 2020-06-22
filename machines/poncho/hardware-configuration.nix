# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];


  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];


  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };



  swapDevices = [ { device = "/dev/disk/by-label/swap"; }];

  nix.maxJobs = lib.mkDefault 4;
}
