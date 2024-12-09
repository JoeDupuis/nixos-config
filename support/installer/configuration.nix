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
    extraGroups = [ "wheel" "storage" "networkmanager" "systemd-journal" "libvirtd" "vboxusers" "scanner" "lp" "adbusers" "docker" "incus-admin"];
    shell = "/run/current-system/sw/bin/fish";
  };


  services.tailscale = {
    enable = true;
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };

  environment.etc = {
    "nixos-config-repo" = {
      source = pkgs.callPackage (
        { runCommand, gitMinimal }:
        runCommand "my-config-repo" { nativeBuildInputs = [ gitMinimal ]; } ''
           HOME=.
           git config --global --add safe.directory '*'
           git clone --bare ${/etc/nixos/.git} $out
          ''
      ) {};
    };

    "emacs-config-repo" = {
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
    (pkgs.callPackage (
      { writeScriptBin }:
      writeShellScriptBin "copy-emacs-config" ''
          rm -rf ~/.emacs.d
          git config --global --add safe.directory /etc/emacs-config-repo
          git clone /etc/emacs-config-repo ~/.emacs.d
          chown -R joedupuis:users ~/.emacs.d
        ''
    ) {})

    (pkgs.callPackage (
      { writeScriptBin }:
      writeShellScriptBin "generate-config" ''
          hostname=''${1:-new-computer}
          nixos-generate-config --root /mnt
          mv /mnt/etc/nixos /mnt/etc/nixos-bak
          git clone /etc/nixos-config-repo /mnt/etc/nixos
          echo "import ./machines/$hostname" > /etc/nixos/configuration.nix
          cd /mnt/etc/nixos
          git remote remove origin
          mv /mnt/etc/nixos-bak /mnt/etc/nixos/machines/new-computer
          chown -R joedupuis:users /mn/etc/nixos
        ''
    ) {})

    (pkgs.callPackage (
      { writeScriptBin, ruby }:
      writeScriptBin "generate-machine-config" ''
          #!${ruby}/bin/ruby
          ${builtins.readFile ./scripts/generate-machine-config}
        ''
    ) {})
    (pkgs.callPackage (
      { writeScriptBin, ruby }:
      writeScriptBin "format-disk" ''
          #!${ruby}/bin/ruby
          ${builtins.readFile ./scripts/disk-formatter.rb}
        ''
    ) {})

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
