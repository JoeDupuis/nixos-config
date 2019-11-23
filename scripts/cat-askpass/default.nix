{writeShellScript, coreutils, ...} :
( writeShellScript "cat-askpass" ''
      exec ${coreutils}/bin/cat
  ''
)
