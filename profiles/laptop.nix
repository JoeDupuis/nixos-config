{ config, pkgs, ... }:
{
  imports = [
    ./desktop.nix
  ];
  # Enable touchpad support.
  services.xserver.libinput.enable = true;
}
