{ writeShellApplication
, ruby
, ffmpeg-full
, curl
, slop
, maim
, xclip
, libnotify
, ... } :
writeShellApplication {
  name = "screenshot";
  runtimeInputs = [ruby ffmpeg-full curl slop maim xclip libnotify];
  text = ''
    # shellcheck source=/dev/null
    set -a && source ~/.config/filecrypt/env && set +a
    op run --no-masking -- ${./screenshot} "$@"
  '';
}
