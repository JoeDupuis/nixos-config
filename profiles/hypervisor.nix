{ config, pkgs, ... }:
{
  imports = [
    ./default.nix
    ./users.nix
  ];
  services.fstrim.enable = true;
  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
  ];

  virtualisation.incus.enable = true;
  networking.nftables.enable = true;
}
