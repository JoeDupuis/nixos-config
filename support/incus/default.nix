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

# nix-build -A container
# incus image import --alias nixos/custom/container result/tarball/nixos-system-x86_64-linux.tar.xz result-2/nixos-lxc-image-x86_64-linux.squashfs
# incus launch nixos/custom/container customnixos -c security.nesting=true
