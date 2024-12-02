let
  f = import ./functions.nix;
  example-p1 = f.part1 ./example-input.txt;
  result-p1 = f.part1 ./puzzle-input.txt;
  example-p2 = f.part2 ./example-input.txt;
  result-p2 = f.part2 ./puzzle-input.txt;
  example-p1-parsed-input = [
    [
      7
      6
      4
      2
      1
    ]
    [
      1
      2
      7
      8
      9
    ]
    [
      9
      7
      6
      2
      1
    ]
    [
      1
      3
      2
      4
      5
    ]
    [
      8
      6
      4
      4
      1
    ]
    [
      1
      3
      6
      7
      9
    ]
  ];
in

assert
  f.getDiffs [
    7
    6
    4
    2
    1
  ] == [
    (-1)
    (-2)
    (-2)
    (-1)
  ];
assert f.isSafe (
  f.getDiffs [
    7
    6
    4
    2
    1
  ]
);
assert
  !f.isSafe (
    f.getDiffs [
      1
      2
      7
      8
      9
    ]
  );
assert
  !f.isSafe (
    f.getDiffs [
      1
      3
      2
      4
      5
    ]
  );
assert
  !f.isSafe (
    f.getDiffs [
      8
      6
      4
      4
      1
    ]
  );
assert f.isSafe (
  f.getDiffs [
    1
    3
    6
    7
    9
  ]
);
assert f.countSafeReports (example-p1-parsed-input) == 2;
assert example-p1 == 2;
assert example-p2 == 4;
''
  Result part 1: ${toString result-p1}
  Result part 2: ${toString result-p2}
''
