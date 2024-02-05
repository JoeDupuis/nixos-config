{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/desktop.nix
    ../../modules/bluetooth.nix
  ];

  networking.hostName = "birdperson";

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    # extraEntries = ''
    #   menuentry "Windows1" {
    #     insmod part_gpt
    #     insmod chain
    #     insmod ntfs
    #     insmod fat
    #     insmod search_fs_uuid
    #     search --fs-uuid --set=root 7cb2e367-01
    #     chainloader /EFI/bootmgr.efi
    #   }
    #   menuentry "Windows2" {
    #     insmod part_gpt
    #     insmod chain
    #     insmod ntfs
    #     insmod fat
    #     insmod search_fs_uuid
    #     search --fs-uuid --set=root 7cb2e367-01
    #     chainloader /bootmgr.efi
    #   }
    #   menuentry "Windows3" {
    #     insmod part_gpt
    #     insmod chain
    #     insmod ntfs
    #     insmod fat
    #     insmod search_fs_uuid
    #     search --fs-uuid --set=root 1a8da801-8f3a-4a17-a7fd-f253146cd8a1
    #     chainloader /EFI/bootmgr.efi
    #   }
    # '';

    efiInstallAsRemovable = true;
  };
  #boot.loader.efi.canTouchEfiVariables = true;

  # services.synergy.server = {
  #   enable = true;
  #   autoStart = false;
  #   address = "192.168.122.1";
  # };

  environment.etc."synergy-server.conf".source = ./synergy-server.conf;

  #24800 synergy
  networking.firewall.interfaces.virbr0.allowedTCPPorts = [24800];




  services.borgbackup.jobs = {
    twistedjoe = {
      encryption.mode = "none";
      repo = "/home/twistedjoe/archives/borg_backup";
      user = "twistedjoe";
      group = "users";
      paths = [
        "/home/twistedjoe/Downloads"
        "/home/twistedjoe/Documents"
        "/home/twistedjoe/Pictures"
        "/home/twistedjoe/Videos"
        "/home/twistedjoe/Music"
        "/home/twistedjoe/Desktop"
        "/home/twistedjoe/Public"
        "/home/twistedjoe/.config/chromium"
      ];
      compression = "lz4";
    };
  };


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
