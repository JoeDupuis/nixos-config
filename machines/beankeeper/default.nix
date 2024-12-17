{ config, lib, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/lxc-container.nix>
    ../../profiles/kamal.nix
    ../lxc-container
  ];

  services.restic.backups.beankeeper = {
    initialize = true;
    environmentFile = "/etc/restic/env";
    repositoryFile = "/etc/restic/repo";
    paths = ["/var/lib/docker/volumes"];
    passwordFile = "/etc/restic/password";
    pruneOpts = [
      "--keep-last 100",
      "--keep-daily 90"
    ];
    timerConfig = {
      OnCalendar = "*:0/15";
    };
  };
}
