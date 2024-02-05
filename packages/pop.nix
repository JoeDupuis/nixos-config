{fetchurl, stdenv}:
stdenv.mkDerivation {
  pname = "pop";
  version = "8.0.18";
  src = fetchurl {
    url = https://download.pop.com/desktop-app/linux/8.0.18/pop_8.0.18_amd64.deb;
    sha256 = "sha256-h4Oua/ZrW8plRNmcwledjLG8jmUCOmZHK8UTJiEa+CE=";
  };

  unpackPhase = ''
    ar -x $src
    tar xvf data.tar.xz
  '';

  installPhase = ''
    mv usr $out
  '';
}
