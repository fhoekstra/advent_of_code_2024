with builtins;
let
  f = import ./functions.nix;
in
assert f.isDigit "0" == true;
assert f.isDigit "r" == false;
assert f.isDigit "3" == true;
assert f.isDigit "_" == false;
assert f.isDigit "33" == false;
assert
  f.filterForDigits ([
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
  f.firstDigit ([
    "r"
    "f"
    "3"
    "dfs"
    "7"
    "e"
  ]) == "3";
assert
  f.lastDigit ([
    "r"
    "f"
    "3"
    "dfs"
    "7"
    "e"
  ]) == "7";
true
