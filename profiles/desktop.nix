{ config, lib, pkgs, ... }:
{
  imports = [
    ./default.nix
    ../modules/yubikey.nix
    ../modules/scan.nix
    ../modules/direnv.nix
    ../modules/teamviewer.nix
  ]
   ++ lib.optional (builtins.pathExists ./hosts.nix) ./hosts.nix;

  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "ntfs" ];

  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;

  environment.variables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    TERMINAL = "alacritty";
  };

  services.xrdp.enable = true;
  #services.xrdp.defaultWindowManager = "startxfce4";
  services.xrdp.defaultWindowManager = "/run/current-system/sw/bin/xfce4-session";
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [3389 3000]; #xrdp

  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = ["twistedjoe"];

  environment.systemPackages = with pkgs; [
    # claude-code  # using FHS module with auto-updates instead (modules/claude-code.nix)
    nodejs
    gist
    ngrok
    nodePackages.localtunnel
    insomnia
    postman
    ledger
    discord
    mumble
    gparted
    tigervnc
    pciutils
    usbutils
    nixos-generators
    polkit_gnome
    xorg.xmodmap
    inetutils
    ntfs3g
    chromium
    google-chrome
    firefox
    nix-index
    irssi
    quasselClient
    rxvt-unicode-unwrapped
    alacritty
    pinentry-curses
    pinentry-emacs
    zip
    unzip
    screenfetch
    xsel
    xclip
    fzf
    libnotify
    pavucontrol
    feh
    maim
    ffmpeg-full
    slop
    imagemagick
    hdparm
    darktable
    rawtherapee
    virt-manager
    playerctl
    gimp
    inkscape
    openvpn
    remmina
    dbeaver-bin
    libreoffice
    pdfarranger
    sshfs
    filezilla
    unison
    autorandr
    mpv
    ffmpegthumbnailer
    shotwell
    ghostscript
    lxappearance
    thunderbolt
    simple-scan
    lz4
    hfsprogs
    screenshot-script
    spotify-script
    vlc
    transmission_4-gtk
    gvfs
    gnupg
    zoom-us
    slack
    vscode
    lightworks
    keepassxc
    devenv
    netcat-gnu
    incus
    dig
    jq
    awscli2
    age
  ];

  #networking.networkmanager.enable = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  services.emacs.defaultEditor = true;
  services.emacs.enable = true;
  systemd.user.services.emacs.environment.RUBY_DEBUG_NO_RELINE = "true";

  services.clipmenu.enable = true;


  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [brlaser];
  };

  programs.dconf.enable = true;


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  virtualisation = {
    # libvirtd.enable = true;
    # libvirtd.qemu.ovmf.enable = true;
    # libvirtd.onBoot = "ignore";
    # virtualbox.host.enable = true;
    # virtualbox.host.enableExtensionPack = true;
    docker.enable = true;
  };

  networking.firewall.checkReversePath = false;

  nixpkgs.overlays = [
    (self: super: {
      pop-video = self.callPackage ../packages/pop.nix {};
      #devenv = self.callPackage ../packages/devenv.nix {};
    })];
}
