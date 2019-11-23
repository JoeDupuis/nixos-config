{writeShellScriptBin, cat-askpass, lastpass-cli, ...} :
( writeShellScriptBin "load-ssh-key" ''
  for filename in ~/.ssh/*.pub; do
	    path=''${filename%".pub"}
	    filename=$(basename $path)
	    ${lastpass-cli}/bin/lpass show --field=Passphrase ssh/$USER@$HOSTNAME:$filename 2> /dev/null | SSH_ASKPASS="${cat-askpass}" ssh-add $path
  done
  ''
)