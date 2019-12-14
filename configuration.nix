# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./scripts
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
  boot.supportedFilesystems = [ "ntfs" ];


  hardware.sane = {
    enable = true;
    snapshot = true;
  };

  networking.hostName = "birdperson"; # Define your hostname.
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.hosts = {
    "172.16.4.254" = ["xs"]; #xrail
    "10.12.0.46" = ["intranet.groupesl.com"];
    "167.99.27.107" = ["stage.myvibe.life" "master.myvibe.life"];
    "157.230.74.252" = ["prod.myvibe.life"];
    "104.27.157.125" = ["production.myvibe.life"];
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    publish.addresses = true;
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # networking.interfaces.enp0s31f6.useDHCP = true;
  # networking.interfaces.wlp112s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/;"
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Select internationalisation properties.
  i18n = {
    #consoleFont = "Lat2-Terminus16";
    consoleFont = "ter-i32b";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    consolePackages = with pkgs; [terminus_font];

  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    nixos-generators
    wget
    gparted
    polkit_gnome
    xorg.xmodmap
    telnet
    file
    ntfs3g
    emacs
    ranger
    tmux
    chromium
    firefox
    nix-index
    irssi
    man
    quasselClient
    rxvt_unicode
    htop
    gksu
    pinentry
    zip
    unzip
    git
    stow
    screenfetch
    xsel
    xclip
    lastpass-cli
    ag
    fzf
    libnotify
    pavucontrol
    feh
    maim
    ffmpeg_4
    slop
    ufraw
    imagemagick7
    hdparm
    darktable
    rawtherapee
    virtmanager
    OVMF
    nixops
    playerctl
    xfce.xfce4-notifyd
    gimp
    inkscape
    ncdu
    openvpn
    remmina
    dbeaver
    libreoffice
    okular
    pdfarranger
    linphone
    sshfs
    unison
    autorandr
    mpv
    ffmpegthumbnailer
    shotwell
    ghostscript
    lxappearance
    thunderbolt
    xsane
    simple-scan
    lz4
    hfsprogs
    gitAndTools.gitflow
    scripts.screenshot
    scripts.shellfish
    scripts.spotify
    scripts.load-ssh-key
  ];

  services.clipmenu.enable = true;
  programs.fish.enable = true;

  services.emacs.defaultEditor = true;
  services.emacs.enable = true;
  systemd.user.services.emacs.wants = ["ssh-agent.service"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  #programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.ssh.startAgent = true;



  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  nixpkgs.overlays = [ (self: super: {
    nixos-generators = self.callPackage ./packages/nixos-generators {};
    xerox6280 = self.callPackage ./packages/xerox6280 {};
    pdfarranger = self.callPackage ./packages/pdfarranger.nix {};
    sane-backends-git  = self.callPackage ./packages/sane-backends/git.nix (config.sane or {});
  })];

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [ xerox6280 brlaser ];
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Xerox";
        deviceUri = "ipp://192.168.1.249/ipp";
        model = "Xerox/Xerox_Phaser_6280DN.ppd.gz";
        ppdOptions = {
          "InstalledMemory" = "256Meg";
          "Option1" = "None"; #Tray config
          "Option2" = "False"; #Storage Device
          "Option3" = "True"; #Duplex unit
          "PageSize" = "Letter";
          "Smoothing" = "False";
        };
      }
    ];
  };



  services.borgbackup.jobs = {
    twistedjoe = {
      encryption.mode = "none";
      repo = "/home/twistedjoe/archives/borg_backup";
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

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;


  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];


  # Enable the X11 windowing system.
    services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.extraPackages = with pkgs; [
        rofi #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  services.xserver = {
    desktopManager.xfce = {
      enable = true;
      enableXfwm = false;
      noDesktop = true;
      thunarPlugins = [ pkgs.xfce.thunar-archive-plugin
                        pkgs.xfce.thunar-volman];
    };

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.twistedjoe = {
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [ "wheel" "networkmanager" "systemd-journal" "libvirtd" "vboxusers" "scanner" "lp"]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgm4SslljVjQqdXEGfSTMi9K+Tai/nS4tPSP8fxwwcZ4efIEe4JtiD54HEoFcyFNe0y5uXExeWUcHwwm6/AkRYasbLa9HPJ/Pu0sqMiuqi6mVZhI00H8jAaunZC4z6HpgtDUJzfkUPcaEuGnDJT1OpqFt5mpgwZ+1WTXPqcWWmLIyVjycl4Iye1aQ1CuSY/adR3TDU4a0bZO5r5kwI63i/dorArgUqx84wvUvJNlD7KVMQtEvBw8ajkeIpC8fVN21/29xU1a60gq8hH8mRz08/N+wKLlC2+DpsZOScvNaXwZnRI4Dmz5Gv05J/L1TYt5jOL6tiBj1jIrFeM5bbVMVX twistedjoe@birdperson"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkFM001QJeFnhB75BRFvwm0xRDBiDmQZP4bNRstK1DIOCpShk91/iK+FUgVxVKp5n4Z925FJh33TDeLYm/F7vQLuJiaa/dRWtVTnIsdAPPQGB+1iFDt5bpBwaCqBUV6mNcAYQu4op1Fy8dzT0ruasic2hrD7sNlIYPpX7lpGX8o1oKhasBZ5ExKGmIKhAlOdSCxVmFmgPHFjFqM9dkNfi+hjWf4BPTkXPVry2zhDcnl4aiyY04FcanMsXcpE75q8FCeKfrvbc1xQQp/Ol/29nuv+Pnb0r7500CFAkQnRd3RxGBa9IS9P+Urbw7ttsxHjEwJ1nnYT31wuoBcWrdeMpj JuiceSSH"
    ];
  };


  virtualisation = {
    libvirtd.enable = true;
    libvirtd.qemuOvmf = true;
    virtualbox.host.enable = true;
    virtualbox.host.enableExtensionPack = true;
  };

  # Needed for nixops libvirtd backend
  # https://nixos.org/nixops/manual/#idm140737322394336
  networking.firewall.checkReversePath = false;


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}
