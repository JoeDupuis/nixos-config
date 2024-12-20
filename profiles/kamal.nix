{ config, pkgs, lib, ... }:
{
  imports = [
    ./default.nix
  ]
  ++ lib.optional (builtins.pathExists ../incus.nix) ../incus.nix;

  virtualisation.docker.enable = true;
  virtualisation.docker.logDriver = "journald";
}
