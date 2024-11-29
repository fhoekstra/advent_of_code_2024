with builtins;
let
  pkgs = import <nixpkgs> { };
  ord = pkgs.lib.strings.charToInt;
  isDigit = c: ((48 <= (ord c)) && ((ord c) <= 57));
  filterForDigits = l: filter isDigit l;
  first = l: elemAt l 0;
  last = l: (elemAt l) ((length l) - 1);
  firstDigit = l: first (filterForDigits l);
  lastDigit = l: last (filterForDigits l);
  splitIntoChars = pkgs.lib.strings.stringToCharacters;
  findFirstDigit = s: firstDigit (splitIntoChars s);
  findLastDigit = s: lastDigit (splitIntoChars s);
  strFromDigits = s: (findFirstDigit s) + (findLastDigit s);
  combineDigits = s: pkgs.lib.strings.toInt (strFromDigits s);
in
{
  isDigit = isDigit;
  filterForDigits = filterForDigits;
  firstDigit = firstDigit;
  lastDigit = lastDigit;
  combineDigits = combineDigits;
}
