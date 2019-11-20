{stdenv, lib, ...} :

stdenv.mkDerivation {
  name = "shellfish";
  src = ./shellfish;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/$name
    chmod 755 $out/bin/$name
  '';
}
