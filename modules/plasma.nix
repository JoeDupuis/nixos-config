{ config, lib, pkgs, ... }:

{
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xrdp.defaultWindowManager = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11";

  # Only enable SDDM if Jovian autoStart is not used
  services.displayManager.sddm.enable = lib.mkDefault (!config.jovian.steam.autoStart or false);

  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.kate
    kdePackages.konsole
    kdePackages.spectacle
  ];
}
