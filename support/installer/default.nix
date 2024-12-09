let
  pkgs = import <nixpkgs>;
  nixos = import <nixpkgs/nixos>;
in
(
  nixos {
    configuration = {
      imports = [
        <nixpkgs/nixos/modules/installer/cd-dvd/iso-image.nix>
        <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
        <nixpkgs/nixos/modules/profiles/all-hardware.nix>
        <nixpkgs/nixos/modules/profiles/base.nix>
        ./configuration.nix
      ];
    };
  }
).config.system.build.isoImage
