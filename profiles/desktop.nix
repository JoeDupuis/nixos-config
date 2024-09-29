{ config, pkgs, ... }:
{
  imports = [
    ./default.nix
    ../modules/avahi.nix
    ../modules/scan.nix
    ../modules/zerotier.nix
    ../modules/direnv.nix
    ../modules/teamviewer.nix
    ./hosts.nix
  ];

  services.fstrim.enable = true;

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
    rxvt_unicode
    alacritty
    pinentry
    pinentry-emacs
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
    ffmpeg-full
    slop
    imagemagick7
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
    scripts.load-ssh-key
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
  ];

  services.keybase.enable = true;
  services.kbfs.enable = true;



  networking.networkmanager.enable = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;


  programs.ssh.startAgent = true;
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


  users.users.twistedjoe = {
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [ "wheel" "storage" "networkmanager" "systemd-journal" "libvirtd" "vboxusers" "scanner" "lp" "adbusers" "docker"];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgm4SslljVjQqdXEGfSTMi9K+Tai/nS4tPSP8fxwwcZ4efIEe4JtiD54HEoFcyFNe0y5uXExeWUcHwwm6/AkRYasbLa9HPJ/Pu0sqMiuqi6mVZhI00H8jAaunZC4z6HpgtDUJzfkUPcaEuGnDJT1OpqFt5mpgwZ+1WTXPqcWWmLIyVjycl4Iye1aQ1CuSY/adR3TDU4a0bZO5r5kwI63i/dorArgUqx84wvUvJNlD7KVMQtEvBw8ajkeIpC8fVN21/29xU1a60gq8hH8mRz08/N+wKLlC2+DpsZOScvNaXwZnRI4Dmz5Gv05J/L1TYt5jOL6tiBj1jIrFeM5bbVMVX twistedjoe@birdperson"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC88Aa8pa+YKCVwxYUD8W5/9L508JnuIiA3Qpo48vdTik3PRHQlA4yzfHpqkJQi4r/veWINRPSIFLQrCTvmPeQjjZ7sbyfTMyxiwFq3de541qP/hwBShn7wwGOO018GZy0Wf8NSjseEuLHa8kxiMByxZYIKctz+P4SwyJayBGey2ijXNFonQW3M5Tn05X11QboXUfJ2SunfJHFcvyUyML4uc7DshZA/ntdn7F6LS67HkCMzOSp9mOxaJvo1W38ZQiNsoSiYP03uTLBR198TsVK9bT+H0KB8Sh1sPFUp0cIMk9c+iy5MVKLYe0R0TJ8CJIUHSdpTloNBvtuQcwRJfROY71u2sZPYSJv+/9H+tykMw+0mI6Jfl+PCRCIqn1X8VRMPXwREF0TCFYuBoKUhT+XeSKWky1m893KvT0eChY0Go7z8wc4KVOBqd/QWC81K9P8X02Xq/0ICFedcUc1Li5VtXZ9j9pPyWcTyeLR+9+WnfHYbL+LZof8072fEEu4iWKM= twistedjoe@butter-robot"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCBlEfsUxFsoed9khhPhQZTfoDyePFNHo03QZPS3DnmQ9Y33zPlTds09n3ilXV26Sn/6lRGe+Dz9Eyk2JDKrvQ3+/Gltb+VaD0Hp2bH+4C/DGj4Fnw9mf98gfBfUrqhd/LkSevDBMRNohl2rHti/BbQZihRhMi0R7E+ui0csGbyxaHhsKKOjjpHEQbzlkHYPNcvth4OieOdsZIdWoTGj0ZsdEOMhrHtJn8P3qoGxCJZ0YAHwJUqocHVIqOhzWhFJ/ibPQSVB5fDROb2NJBBtdUX74hmTKsT64MZQ1/vUIqKgxRmey/TdjcUTwjuzXk7jh/mv1mGPCsnuECRclESBNn twistedjoe@squanchy"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkFM001QJeFnhB75BRFvwm0xRDBiDmQZP4bNRstK1DIOCpShk91/iK+FUgVxVKp5n4Z925FJh33TDeLYm/F7vQLuJiaa/dRWtVTnIsdAPPQGB+1iFDt5bpBwaCqBUV6mNcAYQu4op1Fy8dzT0ruasic2hrD7sNlIYPpX7lpGX8o1oKhasBZ5ExKGmIKhAlOdSCxVmFmgPHFjFqM9dkNfi+hjWf4BPTkXPVry2zhDcnl4aiyY04FcanMsXcpE75q8FCeKfrvbc1xQQp/Ol/29nuv+Pnb0r7500CFAkQnRd3RxGBa9IS9P+Urbw7ttsxHjEwJ1nnYT31wuoBcWrdeMpj JuiceSSH"
    ];
  };

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

}
