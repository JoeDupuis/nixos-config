{ config, pkgs, ... }:
{
  imports = [
    ./default.nix
    ../modules/avahi.nix
    ../modules/scan.nix
    ../modules/zerotier.nix
    ../modules/direnv.nix
    ../modules/teamviewer.nix
    ./users.nix
    ./hosts.nix
  ];

  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "ntfs" ];

  programs.gnupg.agent = {
    enable = true;
  };

  programs.steam.enable = true;

  environment.variables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    TERMINAL = "alacritty";
  };

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startxfce4";
  services.xrdp.openFirewall = true;

  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = ["twistedjoe"];


  environment.systemPackages = with pkgs; [
    gist
    ngrok
    nodePackages.localtunnel
    dmenu
    insomnia
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
    pinentry
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
    OVMF
    playerctl
    xfce.xfce4-notifyd
    gimp
    inkscape
    openvpn
    remmina
    dbeaver-bin
    libreoffice
    okular
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
    gitAndTools.gitflow
    scripts.screenshot
    scripts.shellfish
    scripts.spotify
    vlc
    transmission-gtk
    gvfs
    gnupg
    zoom-us
    keybase-gui
    slack
    vscode
    lightworks
    keepassxc
    devenv
    netcat-gnu
    incus
    dig
  ];

  services.keybase.enable = true;
  services.kbfs.enable = true;



  networking.networkmanager.enable = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  services.emacs.defaultEditor = true;
  services.emacs.enable = true;
  systemd.user.services.emacs.environment.RUBY_DEBUG_NO_RELINE = "true";

  services.clipmenu.enable = true;
  programs.fish.enable = true;


  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [brlaser];
  };

  programs.adb.enable = true;

  programs.dconf.enable = true;


  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.extraPackages = with pkgs; [
    rofi #application launcher most people use
    i3status # gives you the default i3 status bar
    i3lock #default i3 screen locker
    i3blocks #if you are planning on using i3blocks over i3status
  ];

  services.xserver.displayManager.lightdm.enable = true;

  services.xserver = {
    desktopManager.xfce = {
      enable = true;
      enableXfwm = false;
      noDesktop = true;
    };
  };

  programs.thunar.plugins = [
    pkgs.xfce.thunar-archive-plugin
    pkgs.xfce.thunar-volman
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  virtualisation = {
    libvirtd.enable = true;
    libvirtd.qemu.ovmf.enable = true;
    libvirtd.onBoot = "ignore";
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
