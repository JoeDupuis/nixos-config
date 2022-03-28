{ config, pkgs, ... }:
{
  imports = [
    ./default.nix
    ../modules/avahi.nix
    ../modules/zerotier.nix
  ];

  time.timeZone = "America/Montreal";

  boot.extraModulePackages = [];
  boot.supportedFilesystems = [ "ntfs" ];

  environment.systemPackages = with pkgs; [
    gparted
    x11vnc
    polkit_gnome
    xorg.xmodmap
    chromium
    firefox
    rxvt_unicode
    zip
    unzip
    screenfetch
    xsel
    xclip
    fzf
    libnotify
    pavucontrol
    virtmanager
    playerctl
    xfce.xfce4-notifyd
    gimp
    inkscape
    vlc
    gitAndTools.gitflow
  ];




  i18n = {
    #consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale =  pkgs.lib.mkForce "fr_CA.UTF-8";
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


  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [];
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;


  programs.dconf.enable = true;
  services.dbus.packages = with pkgs; [ xfce.dconf gnome2.GConf ];


  services.xserver = {
    enable = true;
    exportConfiguration = true; #needed to list xserver kb layouts
    layout = "ca";
    #xkbVariant = "fr";
    #xkbModel = "pc105";
    displayManager = {
      lightdm = {
        enable = true;
      };
    };
    #desktopManager.plasma5.enable = true;
    desktopManager.xfce = {
      enable = true;
      thunarPlugins = [ pkgs.xfce.thunar-archive-plugin
                        pkgs.xfce.thunar-volman];
    };
  };

  users.users = {
    twistedjoe = {
      isNormalUser = true;
      shell = "/run/current-system/sw/bin/fish";
      extraGroups = [ "wheel" "storage" "networkmanager" "systemd-journal" "libvirtd" "vboxusers" "scanner" "lp" "adbusers"];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgm4SslljVjQqdXEGfSTMi9K+Tai/nS4tPSP8fxwwcZ4efIEe4JtiD54HEoFcyFNe0y5uXExeWUcHwwm6/AkRYasbLa9HPJ/Pu0sqMiuqi6mVZhI00H8jAaunZC4z6HpgtDUJzfkUPcaEuGnDJT1OpqFt5mpgwZ+1WTXPqcWWmLIyVjycl4Iye1aQ1CuSY/adR3TDU4a0bZO5r5kwI63i/dorArgUqx84wvUvJNlD7KVMQtEvBw8ajkeIpC8fVN21/29xU1a60gq8hH8mRz08/N+wKLlC2+DpsZOScvNaXwZnRI4Dmz5Gv05J/L1TYt5jOL6tiBj1jIrFeM5bbVMVX twistedjoe@birdperson"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCBlEfsUxFsoed9khhPhQZTfoDyePFNHo03QZPS3DnmQ9Y33zPlTds09n3ilXV26Sn/6lRGe+Dz9Eyk2JDKrvQ3+/Gltb+VaD0Hp2bH+4C/DGj4Fnw9mf98gfBfUrqhd/LkSevDBMRNohl2rHti/BbQZihRhMi0R7E+ui0csGbyxaHhsKKOjjpHEQbzlkHYPNcvth4OieOdsZIdWoTGj0ZsdEOMhrHtJn8P3qoGxCJZ0YAHwJUqocHVIqOhzWhFJ/ibPQSVB5fDROb2NJBBtdUX74hmTKsT64MZQ1/vUIqKgxRmey/TdjcUTwjuzXk7jh/mv1mGPCsnuECRclESBNn twistedjoe@squanchy"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkFM001QJeFnhB75BRFvwm0xRDBiDmQZP4bNRstK1DIOCpShk91/iK+FUgVxVKp5n4Z925FJh33TDeLYm/F7vQLuJiaa/dRWtVTnIsdAPPQGB+1iFDt5bpBwaCqBUV6mNcAYQu4op1Fy8dzT0ruasic2hrD7sNlIYPpX7lpGX8o1oKhasBZ5ExKGmIKhAlOdSCxVmFmgPHFjFqM9dkNfi+hjWf4BPTkXPVry2zhDcnl4aiyY04FcanMsXcpE75q8FCeKfrvbc1xQQp/Ol/29nuv+Pnb0r7500CFAkQnRd3RxGBa9IS9P+Urbw7ttsxHjEwJ1nnYT31wuoBcWrdeMpj JuiceSSH"
      ];
    };

    roland = {
      isNormalUser = true;
      extraGroups = ["libvirtd"];
    };

    jaqueline = {
      isNormalUser = true;
    };
  };



  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = 	"/run/current-system/sw/bin/xfce4-session";

  virtualisation = {
    libvirtd.enable = true;
    libvirtd.qemuOvmf = true;
  };

  # Needed for nixops libvirtd backend
  # https://nixos.org/nixops/manual/#idm140737322394336
  networking.firewall.checkReversePath = false;
}
