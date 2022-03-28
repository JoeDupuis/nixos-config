{ config, pkgs, ... }:
{
  imports = [
    ../scripts
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
    ag
    ranger
    man
    htop
    git
    stow
    ncdu
    nix-top
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  nixpkgs.overlays = [
    (import ../overlay/nixops.nix)
    (self: super: {
      nixos-generators = self.callPackage ../packages/nixos-generators {};
      pdfarranger = self.callPackage ../packages/pdfarranger.nix {};
      sane-backends-git  = self.callPackage ../packages/sane-backends/git.nix (config.sane or {});
    })];

}
