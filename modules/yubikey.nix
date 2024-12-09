{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-personalization-gui
    yubikey-manager-qt
    yubikey-manager
  ];

  services.udev.packages = with pkgs; [
    yubikey-personalization
    yubikey-personalization-gui
    yubikey-manager-qt
    yubikey-manager
  ];

}
