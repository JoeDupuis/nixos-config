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
    acsOverride = mkOption {
      type = types.bool;
      default = false;
    };

    gpu = mkOption {
      type = types.enum ["nvidia" "amd" "intel"];
      default = "nvidia";
    };
  };

  config = with lib; mkIf cfg.enable (mkMerge [
    {
      boot.kernelModules = [ "vfio_iommu_type1"];
      boot.kernelParams = [ "pcie_acs_override=downstream" "intel_iommu=on" ];
    }

    (mkIf (cfg.enable && cfg.acsOverride) {
      boot.kernelPackages = pkgs.linuxPackages_4_19;
      boot.kernelPatches = [ {
        name = "add-acs-overrides";
        patch = ./add-acs-overrides_4_19.patch;
      }];

    })

    (mkIf (cfg.enable && cfg.gpu == "nvidia") {
      boot.extraModprobeConfig = usb + (if cfg.acsOverride then amd else toString null);
      services.xserver.videoDrivers = mkForce ["nvidia"];
      boot.blacklistedKernelModules = ["amdgpu" "nouveau"];

    })

    (mkIf (cfg.enable && cfg.gpu == "intel") {
      boot.extraModprobeConfig = usb + amd + nvidia;
      services.xserver.videoDrivers = mkForce ["modesetting"];
      boot.blacklistedKernelModules = [ "amdgpu" "nouveau" "nvidia"];
    })

    (mkIf (cfg.enable && cfg.gpu == "amd") {
      boot.extraModprobeConfig = usb + (if cfg.acsOverride then nvidia else toString null);
      services.xserver.videoDrivers = mkForce ["amdgpu"];
      boot.blacklistedKernelModules = ["nouveau" "nvidia"];
    })
  ]);

}
