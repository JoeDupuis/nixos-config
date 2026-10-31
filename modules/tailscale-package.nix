{ lib, pkgs, ... }:
{
  services.tailscale.package =
    if lib.versionAtLeast pkgs.tailscale.version "1.104.4" then
      pkgs.tailscale
    else
      (import (fetchTarball {
        name = "source";
        url = "https://github.com/NixOS/nixpkgs/archive/885ba4d038f10c3d17d7a92e8c3cc185b99c9158.tar.gz";
        sha256 = "0zr2ig7bf6y7lngd06smfgpx0033yza3l9rp0i718pb0gmks5z3v";
      }) { system = pkgs.stdenv.hostPlatform.system; }).tailscale;
}
