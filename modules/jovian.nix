{ config, lib, pkgs, ... }:

{
  imports = [
    (
      let revision = "3e0747d31474cdb182801518e39511eed2c84c91"; in
      builtins.fetchTarball {
        url = "https://github.com/Jovian-Experiments/Jovian-NixOS/archive/${revision}.tar.gz";
        # Run nixos-rebuild once without sha256 to get the correct hash
        # sha256 = "sha256:0000000000000000000000000000000000000000000000000000";
      } + "/modules"
    )
  ];

  jovian.steam = {
    enable = true;
    autoStart = true;
    user = "twistedjoe";
    desktopSession = "plasma";
  };

  jovian.decky-loader.enable = true;
}
