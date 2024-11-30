let
  f = import ./part2.nix;
in
assert f.firstDigit ("rf3d7e") == "3";
assert f.lastDigit ("rf3d7e") == "7";
assert f.combineDigits "rfsun3daojdsauhdas7dsa" == 37;
assert
  f.sumLines [
    "1dashdsa2"
    "dsijd3jsd2fgd"
    "dsakj7dsad"
  ] == 12 + 32 + 77;
# assert f.processFile ./test_input.txt == 12 + 38 + 15 + 77;
assert f.sumLines [ "two1nine" ] == 29;
assert f.sumLines [ "eightwothree" ] == 83;
# assert f.processFile ./test_input_p2.txt == 281;
true
