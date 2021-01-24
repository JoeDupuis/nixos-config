
{ config, lib, pkgs, ... }:
{
  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ./fs.nix
      ./birdpersonGPUSwitch
    ];



  boot.initrd.availableKernelModules = [ "vfio-pci" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" "vfio" "vfio_pci" "vfio_virqfd" "wl"];

  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];


  services.xserver.videoDrivers = ["nvidia"];
  #boot.blacklistedKernelModules = ["amdgpu" "nouveau"];

  specialisation = {
    Intel.configuration = {
      boot.loader.grub.configurationName = lib.mkForce "Intel";
      birdpersonGPUSwitch = {
        enable = true;
        gpu = lib.mkForce "intel";
      };
    };

    Nvidia.configuration = {
      boot.loader.grub.configurationName = lib.mkForce "nvidia";
      birdpersonGPUSwitch = {
        enable = true;
        gpu = lib.mkForce "nvidia";
      };
    };
  };


  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
