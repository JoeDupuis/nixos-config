{writeShellScriptBin, nix, ...} :
( writeShellScriptBin "shellfish" ''
    exec ${nix}/bin/nix-shell --run fish
  ''
)
