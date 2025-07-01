{ config, pkgs, ... }:
{

  imports =
    [
      # This includes the Lix NixOS module in your configuration along with the
      # matching version of Lix itself.
      #
      # The sha256 hashes were obtained with the following command in Lix (n.b.
      # this relies on --unpack, which is only in Lix and CppNix > 2.18):
      # nix store prefetch-file --name source --unpack https://git.lix.systems/lix-project/lix/archive/2.92.0.tar.gz
      #
      # Note that the tag (e.g. 2.92.0) in the URL here is what determines
      # which version of Lix you'll wind up with.
      (let
        module = fetchTarball {
          name = "source";
          url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-1.tar.gz";
          sha256 = "sha256-8oUT6D7VlsuLkms3zBsUaPBUoxucmFq62QdtyVpjq0Y=";
        };
        lixSrc = fetchTarball {
          name = "source";
          url = "https://git.lix.systems/lix-project/lix/archive/2.92.0.tar.gz";
          sha256 = "sha256-CCKIAE84dzkrnlxJCKFyffAxP3yfsOAbdvydUGqq24g=";
        };
        # This is the core of the code you need; it is an exercise to the
        # reader to write the sources in a nicer way, or by using npins or
        # similar pinning tools.
      in import "${module}/module.nix" { lix = lixSrc; }
      )
    ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
	  stow
	  irssi
    fzf
    htop
    emacs
    devenv
    direnv
    tmux
    silver-searcher
    _1password-cli
  ];

  services.tailscale.enable = true;
  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
