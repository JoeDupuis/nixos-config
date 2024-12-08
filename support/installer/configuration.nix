{ pkgs, lib, ... } : {

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;


  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  system.stateVersion = lib.mkDefault lib.trivial.release;

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    packages = with pkgs; [terminus_font];
    keyMap = "us";
    font = "ter-i32b";
  };

  networking.networkmanager.enable = true;

  security.sudo.wheelNeedsPassword = false;
  users.allowNoPasswordLogin = true;
  services.getty.autologinUser = "joedupuis";
  users.extraUsers.joedupuis = {
    initialHashedPassword = lib.mkForce "";
    hashedPassword = lib.mkForce null;
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/fish";
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };

  environment.etc = {
    "my-nixos-config-repo" = {
      source = pkgs.callPackage (
        { runCommand, gitMinimal }:
        runCommand "my-config-repo" { nativeBuildInputs = [ gitMinimal ]; } ''
           HOME=.
           git config --global --add safe.directory '*'
           git clone --bare ${/etc/nixos/.git} $out
          ''
      ) {};
    };

    "my-emacs-config-repo" = {
      source = pkgs.callPackage (
        { runCommand, gitMinimal }:
        runCommand "my-config-repo" { nativeBuildInputs = [ gitMinimal ]; } ''
           HOME=.
           git config --global --add safe.directory '*'
           git clone --bare ${/home/twistedjoe/.emacs.d/.git} $out
          ''
      ) {};
    };
  };

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

    google-chrome
    tailscale
  ];
}
