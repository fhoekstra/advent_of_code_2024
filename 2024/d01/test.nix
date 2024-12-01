let
  f = import ./part1.nix;
  example = ''
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
  '';
  result = f.processStr example;
in
assert result == 11;
result
