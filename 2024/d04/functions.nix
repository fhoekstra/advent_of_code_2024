with builtins;
with import <nixpkgs> { };
with {
  str = lib.strings;
  lst = lib.lists;
  sum = foldl' (
    a: b:
    trace [
      a
      b
    ] (a + b)
  ) 0;
  isX = c: c == "X";
  XMAS = [
    "X"
    "M"
    "A"
    "S"
  ];
};
let
  parse =
    filePath:
    lib.pipe (readFile filePath) [
      (lib.trim)
      (str.splitString "\n")
      (map str.stringToCharacters)
    ];
  countXes =
    g:
    let
      count_occurrences_in_line = lst.count (isX);
      counts = map count_occurrences_in_line g;
    in
    sum counts;
  countXmases =
    g:
    let
      gidx =
        x: y:
        if ((x < 0) || (x >= width)) then
          " "
        else if ((y < 0) || (y >= height)) then
          " "
        else
          elemAt (elemAt g y) x;
      height = length g;
      width = length (elemAt g 0);

      imap2D =
        func:
        lst.imap0 (
          y: row:
          lst.imap0 (
            x: char:
            trace
              {
                x = x;
                y = y;
              }
              func
              {
                c = char;
                x = x;
                y = y;
              }
          ) row
        ) g;
      countXmasesFromSpot =
        args:
        let
          findXmasInDir =
            dx: dy:
            isXmas (
              args
              // {
                dx = dx;
                dy = dy;
                xmasIdx = 0;
              }
            );
        in
        sum [
          (findXmasInDir 1 0)
          (findXmasInDir (-1) 0)
          (findXmasInDir 0 1)
          (findXmasInDir 0 (-1))
          (findXmasInDir 1 1)
          (findXmasInDir 1 (-1))
          (findXmasInDir (-1) (-1))
          (findXmasInDir (-1) 1)
        ];

      isXmas =
        args:
        let
          searchFinished = (args.xmasIdx == 3) && (args.c == (elemAt XMAS args.xmasIdx));
        in
        if searchFinished then 1 else (searchFurther args);

      searchFurther =
        {
          c,
          x,
          y,
          xmasIdx,
          dx,
          dy,
        }:
        if c == (elemAt XMAS xmasIdx) then
          let
            newx = x + dx;
            newy = y + dy;
            newc = gidx newx newy;
          in
          isXmas {
            c = newc;
            x = newx;
            y = newy;
            xmasIdx = xmasIdx + 1;
            dx = dx;
            dy = dy;
          }
        else
          0;

    in
    # trace (isXmas {
    #   x = 5;
    #   y = 0;
    #   dx = 1;
    #   dy = 0;
    #   c = "X";
    #   xmasIdx = 0;
    # }) 1;
    sum2D (imap2D countXmasesFromSpot);
  sum2D = lines: sum (map sum lines);
in
{
  countXes = path: countXes (parse path);
  sum2D = sum2D;
  part1 = path: countXmases (parse path);
}
