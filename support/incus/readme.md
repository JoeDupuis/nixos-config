nix-build -A container
incus image import --alias nixos/custom/container result/tarball/nixos-system-x86_64-linux.tar.xz result-2/nixos-lxc-image-x86_64-linux.squashfs
incus launch nixos/custom/container customnixos -c security.nesting=true

copy-config
passwd <user>
Set the hostname in incus.nix
tailscale up --ssh
