with builtins;
let
  # Let bindings referring to each other is a nice way of building up complex functions.
  # But let's say I want to import this isInt function in many places.
  # How can I make a "nested function code" like this re-usable?
  pkgs = import <nixpkgs> { };
  cast = s: pkgs.lib.strings.toInt s;
  tryCast = t: tryEval (cast t);
  isDigit = c: (tryCast c).success && stringLength c == 1;
  filterForDigits = l: filter isDigit l;
  first = l: elemAt l 0;
  last = l: (elemAt l) ((length l) - 1);
  firstDigit = l: first (filterForDigits l);
  lastDigit = l: last (filterForDigits l);
  splitIntoChars = pkgs.lib.stringToCharacters;
in
{
  isDigit = isDigit;
  filterForDigits = filterForDigits;
  firstDigit = firstDigit;
  lastDigit = lastDigit;
}
