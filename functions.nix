with builtins;
{
  pkgs = import <nixpkgs> { };
  cast = s: pkgs.lib.strings.toInt s;
  tryCast = t: tryEval (cast t);
  isDigit = c: (tryCast c).success && stringLength c == 1;
}
# if I do:
# let f = import ./functions.nix in f.isDigit "3", I get an error:
# undefined variable tryCast
