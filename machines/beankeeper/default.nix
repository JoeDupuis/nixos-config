{ config, lib, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/lxc-container.nix>
    ../../profiles/kamal.nix
    ../lxc-container
  ];

  services.restic.backups.beankeeper = {
    environmentFile = "/etc/restic/env";
    repositoryFile = "/etc/restic/repo";
    passwordFile = "/etc/restic/password";
      timerConfig = {
        OnCalendar = "*:0/15";
      };
  };
}
