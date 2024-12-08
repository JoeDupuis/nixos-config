{ config, lib, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/lxc-container.nix>
    ../../profiles/kamal.nix
  ];

  system.stateVersion = lib.mkDefault lib.trivial.release;
}
