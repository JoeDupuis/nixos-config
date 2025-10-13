{ config, lib, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/lxc-container.nix>
    ../../profiles/kamal.nix
    ../lxc-container
  ];

  networking.hostName = "n8n";

  services.n8n.enable = true
}
