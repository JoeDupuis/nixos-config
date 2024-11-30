{config, pkgs, ...}:
{
  users.users.twistedjoe = {
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [ "wheel" "storage" "networkmanager" "systemd-journal" "libvirtd" "vboxusers" "scanner" "lp" "adbusers" "docker" "incus-admin"];
    openssh.authorizedKeys.keys = import ./ssh_keys.nix;
  };
}
