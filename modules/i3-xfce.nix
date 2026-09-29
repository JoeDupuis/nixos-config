{ config, lib, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.extraPackages = with pkgs; [
    rofi
    i3status
    i3lock
    i3blocks
  ];

  services.xserver.displayManager.lightdm.enable = true;

  services.xrdp.defaultWindowManager = "/run/current-system/sw/bin/xfce4-session";

  services.xserver.desktopManager.xfce = {
    enable = true;
    enableXfwm = false;
    noDesktop = true;
  };

  programs.thunar.plugins = [
    pkgs.xfce.thunar-archive-plugin
    pkgs.xfce.thunar-volman
  ];

  environment.systemPackages = with pkgs; [
    dmenu
    xfce.xfce4-notifyd
  ];
}
