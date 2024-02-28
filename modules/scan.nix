
{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    xsane
  ];

  hardware.sane = {
    enable = true;
    snapshot = true;
    brscan4 = {
      enable = true;
      netDevices = {
        home = {
          name = "brother";
          model = "MFC-L2710DW";
          #nodename = "BRW8CC84B9941EC";
          ip = "192.168.1.69";
        };
      };
    };
  };
}
