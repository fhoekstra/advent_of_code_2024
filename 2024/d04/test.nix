let
  f = import ./functions.nix;
  example-p1 = f.part1 ./example-input.txt;
  result-p1 = f.part1 ./puzzle-input.txt;
in
# example-p2 = f.part2 ./example-input.txt;
# result-p2 = f.part2 ./puzzle-input.txt;

assert f.countXes ./example-input.txt == 19;
assert example-p1 == 18;
# assert example-p2 == 4;
''
  Result part 1: ${toString result-p1}
'' # Result part 2: ${toString result-p2}''
