{ config, pkgs, ... }:
{
  imports = [
    ../scripts
    ../modules/tailscale.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    packages = with pkgs; [terminus_font];
    keyMap = "us";
    font = "ter-i32b";
    #font = "Lat2-Terminus16";
  };


  services.fail2ban.enable = true;


  # Set your time zone.
  time.timeZone = "America/Vancouver";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    file
    emacs
    tmux
    silver-searcher
    ranger
    man
    htop
    git
    stow
    ncdu
    nix-top
  ];

  services.fstrim.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  programs.ssh.startAgent = true;
}
