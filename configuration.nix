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

  networking.hostName = "birdperson"; # Define your hostname.
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.hosts = {
    "172.16.4.254" = ["xs"]; #xrail
    "10.12.0.46" = ["intranet.groupesl.com"];
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
    wget
    xorg.xmodmap
    telnet
    file
    emacs
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
    nixops
    playerctl
    xfce.xfce4-notifyd
    gimp
    inkscape
    ncdu
    openvpn
    remmina
    dbeaver
    pdfarranger
    linphone
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  nixpkgs.overlays = [ (self: super: {
    xerox6280 = self.callPackage ./packages/xerox6280 {};
    pdfarranger = self.callPackage ./packages/pdfarranger.nix {};
  })];

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [ xerox6280 ];
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
        };
      }
    ];
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;





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
    extraGroups = [ "wheel" "networkmanager" "systemd-journal" "libvirtd" "vboxusers"]; # Enable ‘sudo’ for the user.
  };


  virtualisation = {
    libvirtd.enable = true;
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
