{pkgs, stdenv, lib, ...} :

stdenv.mkDerivation {
  name = "screenshot";
  src = ./screenshot;
  dontUnpack = true;

  buildInputs = [ pkgs.ruby pkgs.libnotify ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/$name
    chmod 755 $out/bin/$name
  '';
}
