with builtins;
let
  pkgs = import <nixpkgs> { };
  str = pkgs.lib.strings;
  ord = str.charToInt;
  isDigit = c: ((48 <= (ord c)) && ((ord c) <= 57));
  filterForDigits = l: filter isDigit l;
  first = l: elemAt l 0;
  last = l: (elemAt l) ((length l) - 1);
  firstDigit = l: first (filterForDigits l);
  lastDigit = l: last (filterForDigits l);
  findFirstDigit = s: firstDigit (str.stringToCharacters s);
  findLastDigit = s: lastDigit (str.stringToCharacters s);
  strFromDigits = s: (findFirstDigit s) + (findLastDigit s);
  combineDigits = s: str.toInt (strFromDigits s);
  sum = x: y: x + y;
  reduce = foldl';
  sumLines = lines: reduce sum 0 (map combineDigits lines);
  processFile = f: sumLines (str.splitString "\n" (readFile f));
in
{
  isDigit = isDigit;
  filterForDigits = filterForDigits;
  firstDigit = firstDigit;
  lastDigit = lastDigit;
  combineDigits = combineDigits;
  sumLines = sumLines;
  processFile = processFile;
}
