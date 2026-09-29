{ config, lib, pkgs, ... }:

{
  imports = [
    (
      let revision = "dde76577faacee7682192f26a9b4230526fbc3ed"; in
      builtins.fetchTarball {
        url = "https://github.com/Jovian-Experiments/Jovian-NixOS/archive/${revision}.tar.gz";
        sha256 = "029xp5mkiz18zs2p0zqwwmxxbhj61il8mhyfy8bpdclfd26saqh8";
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
