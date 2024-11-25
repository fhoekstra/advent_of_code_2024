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
in
# TODO: split a string into characters
assert isDigit "0" == true;
assert isDigit "r" == false;
assert isDigit "3" == true;
assert isDigit "_" == false;
assert isDigit "33" == false;
assert
  filterForDigits ([
    "1"
    "r"
    "."
    "5"
    "6"
    "aasd"
    "5488"
  ]) == [
    "1"
    "5"
    "6"
  ];
assert
  firstDigit ([
    "r"
    "f"
    "3"
    "dfs"
    "7"
    "e"
  ]) == "3";
assert
  lastDigit ([
    "r"
    "f"
    "3"
    "dfs"
    "7"
    "e"
  ]) == "7";
true
