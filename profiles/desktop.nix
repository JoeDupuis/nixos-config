{ config, pkgs, ... }:
{
  imports = [
    ./default.nix
    ../modules/avahi.nix
  ];

  services.fstrim.enable = true;

  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
  boot.supportedFilesystems = [ "ntfs" ];

  environment.systemPackages = with pkgs; [
    gparted
    pciutils
    usbutils
    nixos-generators
    polkit_gnome
    xorg.xmodmap
    telnet
    ntfs3g
    chromium
    firefox
    nix-index
    irssi
    quasselClient
    rxvt_unicode
    gksu
    pinentry
    zip
    unzip
    screenfetch
    xsel
    xclip
    lastpass-cli
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
    openvpn
    remmina
    dbeaver
    libreoffice
    okular
    pdfarranger
    #linphone
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



  networking.hosts = {
    "172.16.4.254" = ["xs"]; #xrail
    "172.16.4.252" = ["xrailvm"];
    "10.12.0.46" = ["intranet.groupesl.com"];
    "167.99.27.107" = ["stage.myvibe.life" "master.myvibe.life"];
    "157.230.74.252" = ["prod.myvibe.life"];
    "104.27.157.125" = ["production.myvibe.life"];
    "192.168.122.64" = ["transportmmd.ca" "www.transportmmd.ca"];
  };



  networking.networkmanager.enable = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;


  programs.ssh.startAgent = true;
  services.emacs.defaultEditor = true;
  services.emacs.enable = true;
  systemd.user.services.emacs.wants = ["ssh-agent.service"];


  services.clipmenu.enable = true;
  programs.fish.enable = true;

  hardware.sane = {
    enable = true;
    snapshot = true;
  };


  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      #xerox6280
      brlaser ];
  };

  # hardware.printers = {
  #   ensurePrinters = [
  #     {
  #       name = "Xerox";
  #       deviceUri = "ipp://192.168.1.249/ipp";
  #       model = "Xerox/Xerox_Phaser_6280DN.ppd.gz";
  #       ppdOptions = {
  #         "InstalledMemory" = "256Meg";
  #         "Option1" = "None"; #Tray config
  #         "Option2" = "False"; #Storage Device
  #         "Option3" = "True"; #Duplex unit
  #         "PageSize" = "Letter";
  #         "Smoothing" = "False";
  #       };
  #     }
  #   ];
  # };

  programs.adb.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;


  programs.dconf.enable = true;
  services.dbus.packages = with pkgs; [ xfce.dconf gnome2.GConf ];


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
      thunarPlugins = [ pkgs.xfce.thunar-archive-plugin
                        pkgs.xfce.thunar-volman];
    };
  };

  users.users.twistedjoe = {
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [ "wheel" "storage" "networkmanager" "systemd-journal" "libvirtd" "vboxusers" "scanner" "lp" "adbusers"]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgm4SslljVjQqdXEGfSTMi9K+Tai/nS4tPSP8fxwwcZ4efIEe4JtiD54HEoFcyFNe0y5uXExeWUcHwwm6/AkRYasbLa9HPJ/Pu0sqMiuqi6mVZhI00H8jAaunZC4z6HpgtDUJzfkUPcaEuGnDJT1OpqFt5mpgwZ+1WTXPqcWWmLIyVjycl4Iye1aQ1CuSY/adR3TDU4a0bZO5r5kwI63i/dorArgUqx84wvUvJNlD7KVMQtEvBw8ajkeIpC8fVN21/29xU1a60gq8hH8mRz08/N+wKLlC2+DpsZOScvNaXwZnRI4Dmz5Gv05J/L1TYt5jOL6tiBj1jIrFeM5bbVMVX twistedjoe@birdperson"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCBlEfsUxFsoed9khhPhQZTfoDyePFNHo03QZPS3DnmQ9Y33zPlTds09n3ilXV26Sn/6lRGe+Dz9Eyk2JDKrvQ3+/Gltb+VaD0Hp2bH+4C/DGj4Fnw9mf98gfBfUrqhd/LkSevDBMRNohl2rHti/BbQZihRhMi0R7E+ui0csGbyxaHhsKKOjjpHEQbzlkHYPNcvth4OieOdsZIdWoTGj0ZsdEOMhrHtJn8P3qoGxCJZ0YAHwJUqocHVIqOhzWhFJ/ibPQSVB5fDROb2NJBBtdUX74hmTKsT64MZQ1/vUIqKgxRmey/TdjcUTwjuzXk7jh/mv1mGPCsnuECRclESBNn twistedjoe@squanchy"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkFM001QJeFnhB75BRFvwm0xRDBiDmQZP4bNRstK1DIOCpShk91/iK+FUgVxVKp5n4Z925FJh33TDeLYm/F7vQLuJiaa/dRWtVTnIsdAPPQGB+1iFDt5bpBwaCqBUV6mNcAYQu4op1Fy8dzT0ruasic2hrD7sNlIYPpX7lpGX8o1oKhasBZ5ExKGmIKhAlOdSCxVmFmgPHFjFqM9dkNfi+hjWf4BPTkXPVry2zhDcnl4aiyY04FcanMsXcpE75q8FCeKfrvbc1xQQp/Ol/29nuv+Pnb0r7500CFAkQnRd3RxGBa9IS9P+Urbw7ttsxHjEwJ1nnYT31wuoBcWrdeMpj JuiceSSH"
    ];
  };


  virtualisation = {
    libvirtd.enable = true;
    libvirtd.qemuOvmf = true;
    # virtualbox.host.enable = true;
    # virtualbox.host.enableExtensionPack = true;
  };

  # Needed for nixops libvirtd backend
  # https://nixos.org/nixops/manual/#idm140737322394336
  networking.firewall.checkReversePath = false;

}
