with builtins;
let
  t = import ./print_test.nix;
  f = import ./functions.nix;
  testResult =
    { name, testFunc }: if (tryEval (testFunc).success) then "SUCCESS:" + name else "FAILED:  " + name;
in
assert f.isDigit "0" == true;
assert f.isDigit "!" == false;
assert f.isDigit "3" == true;
assert f.isDigit "_" == false;
assert f.isDigit "r" == false;
assert
  f.filterForDigits ([
    "1"
    "r"
    "."
    "5"
    "6"
    "a"
    "q"
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
    "d"
    "7"
    "e"
  ]) == "3";
assert
  f.lastDigit ([
    "r"
    "f"
    "3"
    "d"
    "7"
    "e"
  ]) == "7";
assert f.combineDigits "rfsun3daojdsauhdas7dsa" == 37;
assert
  f.sumLines [
    "1dashdsa2"
    "dsijd3jsd2fgd"
    "dsakj7dsad"
  ] == 12 + 32 + 77;
true
