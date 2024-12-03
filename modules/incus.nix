{ config, pkgs, ... }:
{
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };

  #incus ui
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 8443 ];

  networking.firewall.trustedInterfaces = [ "incusbr0" ];

  networking.nftables.enable = true;
}
