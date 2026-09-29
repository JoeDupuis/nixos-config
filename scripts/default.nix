{ config, pkgs, ... }: {
  nixpkgs.overlays = [ (self: super: {
    screenshot-script = self.callPackage ./screenshot {};
    spotify-script = self.callPackage ./spotify {};
  })];
}
