{ config, pkgs, ... }: rec {
  nixpkgs.overlays = [ (self: super: {
    scripts = {
      screenshot = pkgs.callPackage ./screenshot {};
      shellfish = pkgs.callPackage ./shellfish {};
      spotify = pkgs.callPackage ./spotify {};
      load-ssh-key = pkgs.callPackage ./load-ssh-key { };
    };
  })];
}
