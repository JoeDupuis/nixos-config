# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "birdperson"; # Define your hostname.
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;


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
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    emacs
    tmux
    chromium
    nix-index
    irssi
    man
    quasselClient
    rxvt_unicode
    htop
    gksu
    pinentry
    unzip
    git
    stow
    screenfetch
    xsel
    xclip
    lastpass-cli
    ruby
    ag
    fzf
    libnotify
    pavucontrol
    feh
    maim
    ffmpeg_4
    slop
  ];

  services.clipmenu.enable = true;
  programs.fish.enable = true;

  services.emacs.defaultEditor = true;
  services.emacs.enable = true;
  services.emacs.install = true;
  systemd.user.services.emacs.environment.SSH_AUTH_SOCK = "%h/.gnupg/S.gpg-agent.ssh";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  #programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.ssh.startAgent = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;




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
    };

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.twistedjoe = {
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [ "wheel" "networkmanager" "systemd-journal"]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}
