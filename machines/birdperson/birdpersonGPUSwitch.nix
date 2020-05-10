{ config, lib, pkgs, ... }:
let
  cfg = config.birdpersonGPUSwitch;
in {

  options.birdpersonGPUSwitch = with lib; {
    enable = mkEnableOption "Birdperson GPU switch";
    gpu = mkOption {
      type = types.enum ["noACS" "nvidia" "amd" "intel"];
      default = "noACS";
    };
  };

  config = with lib; (mkMerge [
    (mkIf (cfg.gpu == "noACS") {

      services.xserver.videoDrivers = ["nvidia"];
      boot.blacklistedKernelModules = [
        "amdgpu"
        "nouveau"
      ];
    })

    (mkIf (cfg.gpu == "nvidia") {
      # AMD 1002:aaf0,1002:67df
      # NVIDIA 10de:13c2,10de:0fbb
      # ASMEDIA USB  1b21:1242
      # Intel USB 8086:a12f
      # Pcie controller16x 8086:1901
      # Pcie controller8x 8086:1905
      boot.extraModprobeConfig = let
        usb =  "1b21:1242";
        amd = ",8086:1905,1002:aaf0,1002:67df"; #AMD
        nvidia = ",8086:1901,10de:13c2,10de:0fbb";
      in
        usb
        + amd
      ;

      services.xserver.videoDrivers = ["nvidia"];
      boot.blacklistedKernelModules = [
        "amdgpu"
        "nouveau"
      ];

      boot.kernelPatches = [ {
        name = "add-acs-overrides";
        patch = ./add-acs-overrides.patch;
      } ];


    })


    (mkIf (cfg.gpu == "intel") {
      # AMD 1002:aaf0,1002:67df
      # NVIDIA 10de:13c2,10de:0fbb
      # ASMEDIA USB  1b21:1242
      # Intel USB 8086:a12f
      # Pcie controller16x 8086:1901
      # Pcie controller8x 8086:1905
      boot.extraModprobeConfig = let
        usb =  "1b21:1242";
        amd = ",8086:1905,1002:aaf0,1002:67df";
        nvidia = ",8086:1901,10de:13c2,10de:0fbb";
      in
        usb
        + amd
        + nvidia
      ;

      services.xserver.videoDrivers = ["modesetting"];
      boot.blacklistedKernelModules = [ "amdgpu"
                                        "nouveau"
                                        "nvidia"
                                      ];

      boot.kernelPatches = [ {
        name = "add-acs-overrides";
        patch = ./add-acs-overrides.patch;
      } ];

    })

    (mkIf (cfg.gpu == "amd") {
      # AMD 1002:aaf0,1002:67df
      # NVIDIA 10de:13c2,10de:0fbb
      # ASMEDIA USB  1b21:1242
      # Intel USB 8086:a12f
      # Pcie controller16x 8086:1901
      # Pcie controller8x 8086:1905
      boot.extraModprobeConfig = let
        usb =  "1b21:1242";
        amd = ",8086:1905,1002:aaf0,1002:67df"; #AMD
        nvidia = ",8086:1901,10de:13c2,10de:0fbb";
      in
        usb
        + nvidia
      ;

      services.xserver.videoDrivers = ["amdgpu"];
      boot.blacklistedKernelModules = [
        "nouveau"
        "nvidia"
      ];

      boot.kernelPatches = [ {
        name = "add-acs-overrides";
        patch = ./add-acs-overrides.patch;
      } ];

    })
  ]);

}
