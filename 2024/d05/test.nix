let
  f = import ./functions.nix;
  example-p1 = f.part1 ./example-input.txt;
  result-p1 = f.part1 ./puzzle-input.txt;
  example-p2 = f.part2 ./example-input.txt;
  result-p2 = f.part2 ./puzzle-input.txt;
in

assert example-p1 == 143;
assert example-p2 == 123;
''Result part 1: ${toString result-p1}'' + '';  Result part 2: ${toString result-p2}''
