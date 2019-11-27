{ callPackage
, fetchFromGitLab
, autoreconfHook
, autoconf-archive
, ... } @ args:

let
  # Version used to sastisfy `autoreconf`.
  upstreamVersion = "1.0.28";
  dirty = "${rev}";
  rev = "3dff8085e771ca945fc46fd93cdf2eb8454e8470";
in
(callPackage ./generic.nix (args // {
  # Actual version for Nixpkgs; we rather use the commit date.
  version = "2019-11-24";

  # We'll rely on fetchFromGitLab... using fetchgit with leaveDotGit doesn't
  # work as expected for git describe anyway.
  src = fetchFromGitLab {
    inherit rev;
    owner = "sane-project";
    repo = "backends";
    sha256 = "1bpz1n3j9m7l4jqw3kw6wf5h0srpwaald0sknrvijqfcfzl6vn0r";
  };
})).overrideAttrs(old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [
    autoconf-archive
    autoreconfHook
  ];

  postPatch = ''
    # git describe will fail.
    substituteInPlace configure.ac \
      --replace "m4_esyscmd_s([git describe --dirty])" "[${upstreamVersion}-${dirty}]"
  '';
})
