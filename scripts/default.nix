{ config, pkgs, ... }: rec {
  nixpkgs.overlays = [ (self: super: {
    scripts = {
      screenshot = pkgs.callPackage ./screenshot {};
      spotify = pkgs.callPackage ./spotify {};
    };
  })];
}
