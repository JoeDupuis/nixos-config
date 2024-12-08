{ pkgs, lib, ... }: {
  imports = [
    ../../profiles/kamal.nix
  ];

  environment.etc."nixos-config-repo" = {
    user = "twistedjoe";
    group = "users";
    source = pkgs.callPackage (
        { runCommand, gitMinimal }:
        runCommand "my-config-repo" { nativeBuildInputs = [ gitMinimal ]; } ''
           HOME=.
           git config --global --add safe.directory '*'
           git clone --bare ${/etc/nixos/.git} $out
          ''
      ) {};
  };

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage (
      { writeScriptBin }:
      writeShellScriptBin "copy-config" ''
          type=''${1:-lxc-container}
          rm -rf /etc/nixos
          git clone /etc/nixos-config-repo /etc/nixos
          cd /etc/nixos
          git remote remove origin
          git remote add origin git@github.com:JoeDupuis/nixos-config.git
          echo "import ./machines/$type" > /etc/nixos/configuration.nix
          echo '{ pkgs, lib, ...}: { networking.hostName = "nixos"; }' > /etc/nixos/incus.nix
          chown -R twistedjoe:users /etc/nixos
        ''
    ) {})
  ];

  system.stateVersion = lib.mkDefault lib.trivial.release;
}
