{ config, pkgs, ... }:
{
  imports = [
    ../scripts
  ];

  i18n = {
    #consoleFont = "Lat2-Terminus16";
    consoleFont = "ter-i32b";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    consolePackages = with pkgs; [terminus_font];

  };


  services.fail2ban.enable = true;


  # Set your time zone.
  time.timeZone = "America/Montreal";

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
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  nixpkgs.overlays = [ (self: super: {
    nixos-generators = self.callPackage ../packages/nixos-generators {};
    #xerox6280 = self.callPackage ../packages/xerox6280 {};
    pdfarranger = self.callPackage ../packages/pdfarranger.nix {};
    sane-backends-git  = self.callPackage ../packages/sane-backends/git.nix (config.sane or {});
  })];

}
