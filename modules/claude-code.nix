{pkgs, ...}:

let
  claude-install = pkgs.buildFHSEnv {
    name = "claude-install";
    targetPkgs = pkgs: with pkgs; [
      glibc
      stdenv.cc.cc.lib
      zlib
      curl
      bash
      coreutils
      nodejs
      git
    ];
    runScript = pkgs.writeScript "install-claude" ''
      #!/bin/bash
      curl -fsSL https://claude.ai/install.sh | bash
    '';
  };

in {
  environment.systemPackages = [ claude-install ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
  ];
}
