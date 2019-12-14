{ stdenv, lib, fetchFromGitHub, makeWrapper, coreutils, jq, findutils, nix  }:

stdenv.mkDerivation rec {
  pname = "nixos-generators";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixos-generators";
    rev = "95f5810ef488e6e87ae0e8be7ccd7a735d8a3f13";
    sha256 = "00r5i4d2cipyjpkvn20fjv7lycw2qq6z9wxb0f1kr75y977imnnd";
  };
  nativeBuildInputs = [ makeWrapper ];
  installFlags = [ "PREFIX=$(out)" ];
  postFixup = ''
    wrapProgram $out/bin/nixos-generate \
      --prefix PATH : ${lib.makeBinPath [ jq coreutils findutils nix ] }
  '';

  meta = with stdenv.lib; {
    description = "Collection of image builders";
    homepage    = "https://github.com/nix-community/nixos-generators";
    license     = licenses.mit;
    maintainers = with maintainers; [ lassulus ];
    platforms   = platforms.unix;
  };
}
