let
  f = import ./part2.nix;
  example = ''
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
  '';
  example-result = f.processStr example;
  example-file-result = f.processFile ../example-input.txt;
  result = f.processFile ../puzzle-input.txt;
in
assert example-result == 31;
assert example-file-result == example-result;
result
