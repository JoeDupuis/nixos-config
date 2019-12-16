{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/desktop.nix
  ];

  networking.hostName = "birdperson";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


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
