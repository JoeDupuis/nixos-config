{ config, pkgs, ... }:
{
  #need the services for it work
  services.teamviewer.enable   = true;
  #environment.systemPackages = with pkgs; [teamviewer];
  #networking.firewall.allowedTCPPorts = [ 5938 ];
  #networking.firewall.allowedUDPPorts = [ 5938 ];
}
