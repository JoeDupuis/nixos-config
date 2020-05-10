{ config, lib, pkgs, ... }:
let
  cfg = config.birdpersonGPUSwitch;
  # AMD 1002:aaf0,1002:67df
  # NVIDIA 10de:13c2,10de:0fbb
  # ASMEDIA USB  1b21:1242
  # Intel USB 8086:a12f
  # Pcie controller16x 8086:1901
  # Pcie controller8x 8086:1905
  usb =  "1b21:1242";
  amd = ",8086:1905,1002:aaf0,1002:67df";
  nvidia = ",8086:1901,10de:13c2,10de:0fbb";


in {


  options.birdpersonGPUSwitch = with lib; {
    enable = mkEnableOption "Birdperson GPU switch";
    gpu = mkOption {
      type = types.enum ["noACS" "nvidia" "amd" "intel"];
      default = "nvidia";
    };
  };

  config = with lib; (mkMerge [
    {
      boot.kernelModules = [ "vfio_iommu_type1"];
      boot.kernelParams = [ "pcie_acs_override=downstream" "intel_iommu=on" ];
      boot.kernelPatches = [ {
        name = "add-acs-overrides";
        patch = ./add-acs-overrides.patch;
      }];
    }

    (mkIf (cfg.enable && cfg.gpu == "nvidia") {
      boot.extraModprobeConfig = usb + amd;
      services.xserver.videoDrivers = mkForce ["nvidia"];
      boot.blacklistedKernelModules = ["amdgpu" "nouveau"];

    })

    (mkIf (cfg.enable && cfg.gpu == "intel") {
      boot.extraModprobeConfig = usb + amd + nvidia;
      services.xserver.videoDrivers = mkForce ["modesetting"];
      boot.blacklistedKernelModules = [ "amdgpu" "nouveau" "nvidia"];
    })

    (mkIf (cfg.enable && cfg.gpu == "amd") {
      boot.extraModprobeConfig = usb + nvidia;
      services.xserver.videoDrivers = mkForce ["amdgpu"];
      boot.blacklistedKernelModules = ["nouveau" "nvidia"];
    })
  ]);

}
