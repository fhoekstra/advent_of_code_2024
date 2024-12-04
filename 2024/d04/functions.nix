with builtins;
with import <nixpkgs> { };
with {
  str = lib.strings;
  lst = lib.lists;
  sum = foldl' (a: b: (a + b)) 0;
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

  imap2D =
    func:
    lst.imap0 (
      y: row:
      lst.imap0 (
        x: char:
        # trace { x = x; y = y;}
        func {
          c = char;
          x = x;
          y = y;
        }
      ) row
    );

  countXmasesp2 =
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

      countXmasesFromA =
        args:
        let
          findMasInDir =
            dx: dy:
            isMas (
              args
              // {
                dx = dx;
                dy = dy;
                x = args.x - dx;
                y = args.y - dy;
              }
            );
          isMas = 1;
        in
        "countXmasesFromA";
    in
    "countXmasesInWholeGrid";

  countXmasesp1 =
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
                wordIdx = 0;
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

      isXmas = isWord XMAS;
      isWord =
        wordAsList:
        let
          thisWord = wordAsList;
          lastIndex = (length thisWord) - 1;
          isThisWord =
            args:
            let
              searchFinished = (args.wordIdx == lastIndex) && (args.c == (elemAt thisWord args.wordIdx));
            in
            if searchFinished then 1 else (searchFurther args);

          searchFurther =
            {
              c,
              x,
              y,
              wordIdx,
              dx,
              dy,
            }:
            if c == (elemAt thisWord wordIdx) then
              let
                newx = x + dx;
                newy = y + dy;
                newc = gidx newx newy;
              in
              isThisWord {
                c = newc;
                x = newx;
                y = newy;
                wordIdx = wordIdx + 1;
                dx = dx;
                dy = dy;
              }
            else
              0;
        in
        isThisWord;

    in
    sum2D (imap2D countXmasesFromSpot g);
  sum2D = lines: sum (map sum lines);
in
{
  countXes = path: countXes (parse path);
  sum2D = sum2D;
  part1 = path: countXmasesp1 (parse path);
}
