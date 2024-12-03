{ config, pkgs, ... }:
{
  imports = [
    ./default.nix
    ./users.nix
    ../modules/incus.nix
  ];
  services.fstrim.enable = true;
  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
  ];

}
