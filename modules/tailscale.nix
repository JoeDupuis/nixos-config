{ config, pkgs, ... }:
{
  services.tailscale = {
    enable = true;
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
