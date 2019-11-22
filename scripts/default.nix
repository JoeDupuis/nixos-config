{ config, pkgs, ... }: {
  nixpkgs.overlays = [ (self: super: {
    scripts = {
      screenshot = pkgs.callPackage ./screenshot {};
      shellfish = pkgs.callPackage ./shellfish {};
      spotify = pkgs.callPackage ./spotify {};
    };
  })];
}
