nix-build
#use the iso

copy-emacs-config #for emacs
tailscale up # for ssh

generate-machine-config
format-disk
generate-config

# compate the generated config in ~/machines/***
# to the generated hardware config in /mnt/etc/nixos/machine/HOSTNAME/hardware-configuration.nix
# DONT FORGET TO ADD A PROFILE!

sudo nixos-install
