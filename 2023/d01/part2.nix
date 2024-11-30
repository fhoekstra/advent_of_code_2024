with builtins;
let
  pkgs = import <nixpkgs> { };
  str = pkgs.lib.strings;
  lst = pkgs.lib.lists;
  fwdDigitsMap = {
    one = "1";
    two = "2";
    three = "3";
    four = "4";
    five = "5";
    six = "6";
    seven = "7";
    eight = "8";
    nine = "9";
  };
  revDigitsMap = {
    eno = "1";
    owt = "2";
    eerht = "3";
    ruof = "4";
    evif = "5";
    xis = "6";
    neves = "7";
    tghie = "8";
    enin = "9";
  };
  findDigit =
    digitsMap: line:
    if stringLength line == 0 then
      "0"
    else
      let
        first = x: elemAt x 0;
        matches = match rePattern line;
        firstMatch = first matches;
        rePattern = str.concatStrings (
          [ "[a-z]*?(" ] ++ [ (str.concatStringsSep "|" digitLikeStuff) ] ++ [ ").*" ]
        );
        digitLikeStuff = digitNames ++ digits;
        digitNames = attrNames digitsMap;
        digits = attrValues digitsMap;
      in
      trace matches (digitsMap.${firstMatch} or firstMatch);
  firstDigit = findDigit fwdDigitsMap;
  lastDigit =
    l:
    let
      reverseStr = s: str.concatStrings (lst.reverseList (str.stringToCharacters s));
    in
    findDigit revDigitsMap (reverseStr l);
  strFromDigits = l: (firstDigit l) + (lastDigit l);
  combineDigits = l: if stringLength l == 0 then 0 else str.toInt (strFromDigits l);
  sum = x: y: x + y;
  reduce = foldl';
  sumLines = lines: reduce sum 0 (map combineDigits lines);
  processFile = f: sumLines (str.splitString "\n" (readFile f));
in
{
  firstDigit = firstDigit;
  lastDigit = lastDigit;
  combineDigits = combineDigits;
  sumLines = sumLines;
  processFile = processFile;
}
