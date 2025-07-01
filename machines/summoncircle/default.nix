{ config, lib, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/lxc-container.nix>
    ../lxc-container
  ];


 networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.interfaces."br-6759ce72fa49".allowedTCPPorts = [ 2375 ];

  virtualisation.docker.daemon.settings = {
    hosts = [
      "unix:///var/run/docker.sock"
      "tcp://0.0.0.0:2375"
    ];
  };

}
