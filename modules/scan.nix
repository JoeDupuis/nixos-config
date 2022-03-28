
{ config, pkgs, ... }:
let
  brscan4_491 = (import (builtins.fetchTarball {
    name = "nixpkgs-unstable";
    url = "https://github.com/nixos/nixpkgs/archive/2394284537b89471c87065b040d3dedd8b5907fe.tar.gz";
    sha256 = "1j7vp735is5d32mbrgavpxi3fbnsm6d99a01ap8gn30n5ysd14sl";
  }) {config.allowUnfree = true;}).brscan4;
in
{
  imports = [
    <nixpkgs/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix>
  ];
  environment.systemPackages = with pkgs; [
    xsane
  ];

  nixpkgs.overlays = [
    (self: super: {
      brscan4 = brscan4_491;
    })
  ];

  hardware.sane = {
    enable = true;
    snapshot = true;
    brscan4 = {
      enable = true;
      netDevices = {
        home = {
          name = "brother";
          model = "MFC-L2710DW";
          #nodename = "BRW8CC84B9941EC";
          ip = "192.168.1.69";
        };
      };
    };
  };
}
