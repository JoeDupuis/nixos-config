{ config, pkgs, ... }:

{
  services.zerotierone = {
    enable = true;
    joinNetworks = ["e5cd7a9e1c61ad1e"];
  };

}
