let
  f = import ./functions.nix;
  example-p1 = f.part1 ./example-input.txt;
  result-p1 = f.part1 ./puzzle-input.txt;
  example-p2 = f.part2 ./example-input.txt;
  result-p2 = f.part2 ./puzzle-input.txt;
in

assert f.countXes ./example-input.txt == 19;
assert
  (f.sum2D [
    [
      1
      2
      3
    ]
    [
      4
      5
      6
    ]
    [
      7
      8
      9
    ]
  ]) == 45;
assert example-p1 == 18;
assert example-p2 == 9;
''
  Result part 1: ${toString result-p1}
  Result part 2: ${toString result-p2}''
