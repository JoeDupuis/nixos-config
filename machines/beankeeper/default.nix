{ config, lib, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/lxc-container.nix>
    ../../profiles/kamal.nix
    ../lxc-container
  ];

  services.restic.backups.beankeeper = {
    environmentFile = "/etc/restic/env";
      timerConfig = {
        OnCalendar = "*:0/15";
      };
  };
}
