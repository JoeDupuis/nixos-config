let
  pkgs = import <nixpkgs>;
  nixos = import <nixpkgs/nixos>;
  container = (nixos {
    configuration = {
      imports = [
        <nixpkgs/nixos/modules/virtualisation/lxc-container.nix>
        ./configuration.nix
      ];
    };
  }
  ).config.system.build;
in
{
  container = {
    inherit (container) squashfs metadata;
  };
}
